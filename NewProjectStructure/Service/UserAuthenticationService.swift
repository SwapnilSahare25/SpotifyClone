//
//  LoginService.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation
import Alamofire
import SafariServices
import UIKit
import CommonCrypto


class UserAuthenticationService {
  static let shared = UserAuthenticationService()
  private init() {}

  private var safariVC: SFSafariViewController?
  //NEW: Storage for the verifier
  private var codeVerifier: String?

  //NEW: Generates a random string for the verifier
  private func generateRandomString(length: Int) -> String {
    let charset: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
    return String((0..<length).map{ _ in charset.randomElement()! })
  }
  //NEW: Generates the SHA256 hashed, Base64URL-encoded challenge
  private func generateCodeChallenge(from verifier: String) -> String? {
    guard let data = verifier.data(using: .utf8) else { return nil }

    // 1. Hash the verifier using SHA256
    var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    data.withUnsafeBytes {
      _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
    }

    // 2. Base64URL-encode the hash
    let challenge = Data(hash).base64EncodedString()
      .replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "/", with: "_")
      .replacingOccurrences(of: "=", with: "")

    return challenge
  }


  // Step 1: Get Authorization URL
  private func getAuthURL() -> URL? {
    // Generate and store the verifier, then generate the challenge
    let verifier = generateRandomString(length: 128)
    codeVerifier = verifier
    guard let challenge = generateCodeChallenge(from: verifier) else { return nil }

    // Correct the Host URL constant (Assuming 'Host' is a global constant)
    // NOTE: Ensure your Host constant is set to "https://accounts.spotify.com/authorize"
    let redirect = redirectUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let scopeEncoded = scopes.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

    // Append code_challenge and code_challenge_method=S256
    let urlString = AuthorizeUrl+"?response_type=code&client_id=\(spotifyClientID)&scope=\(scopeEncoded)&redirect_uri=\(redirect)&code_challenge=\(challenge)&code_challenge_method=S256"

    return URL(string: urlString)
  }
  // Step 2: Open Spotify login page in SFSafariViewController
  func login(from viewController: UIViewController) {
    guard let url = getAuthURL() else { return }
    safariVC = SFSafariViewController(url: url)
    viewController.present(safariVC!, animated: true)
  }

  func logout() {
    isUserLoggedIn = false
    KeychainService.shared.delete(key: "spotify_access_token")
    KeychainService.shared.delete(key: "spotify_refresh_token")
    spotifyTokenExpiry = nil
    userId = 0
    let loginVc = LoginViewController()
    WindowManager.shared.setRootController(loginVc, animated: true)
  }


  func exchangeCodeForToken(code: String, completion: @escaping (Result<SpotifyTokenObject, AFError>) -> Void) {
    let url = "https://accounts.spotify.com/api/token"

    // Safely unwrap and clear the verifier
    guard let verifier = codeVerifier else {
      print("Error: Code verifier not available.")
      completion(.failure(AFError.responseValidationFailed(reason: .customValidationFailed(error: NSError()))))
      return
    }
    codeVerifier = nil

    let params: [String: String] = [
      "grant_type": "authorization_code",
      "code": code,
      "redirect_uri": redirectUrl,
      "client_id": spotifyClientID,
      //"client_secret": spotifyClientSecret
      "code_verifier": verifier
    ]

    let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]


    AF.request(url,method: .post,parameters: params,encoder: URLEncodedFormParameterEncoder.default,headers: headers).validate()
      .responseDecodable(of: SpotifyTokenObject.self) { response in

        switch response.result {
        case .success(let token):
          // Save access token
          print("Token Exchange SUCCESS! Access Token:", token.access_token)
          KeychainService.shared.save(key: "spotify_access_token", value: token.access_token)
          // Save refresh token
          if let refresh = token.refresh_token {
            KeychainService.shared.save(key: "spotify_refresh_token", value: refresh)
          }
          spotifyTokenExpiry = Date().addingTimeInterval(TimeInterval(token.expires_in))
          // SYNC WITH BACKEND

          self.syncUserWithBackend { _ in }
            completion(.success(token))

        case .failure(let error):
          print("Token Exchange FAILURE! Error: \(error.localizedDescription)")
          completion(.failure(error))
        }


      }
  }

  func refreshAccessToken(completion: @escaping (Bool) -> Void) {

         guard let refreshToken = KeychainService.shared.load(key: "spotify_refresh_token") else {
             print("Refresh token not found.")
             completion(false)
             return
         }

         let url = "https://accounts.spotify.com/api/token"

         let params: [String: String] = [
             "grant_type": "refresh_token",
             "refresh_token": refreshToken,
             "client_id": spotifyClientID
         ]

         let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]

         AF.request(url, method: .post, parameters: params, encoder: URLEncodedFormParameterEncoder.default, headers: headers)
             .validate()
             .responseDecodable(of: SpotifyTokenObject.self) { response in

                 switch response.result {
                 case .success(let token):
                    // print("Refresh SUCCESS → New Access Token:", token.access_token)

                     // Save updated access token
                     KeychainService.shared.save(key: "spotify_access_token", value: token.access_token)

                     if let newRefresh = token.refresh_token {
                         KeychainService.shared.save(key: "spotify_refresh_token", value: newRefresh)
                     }
                   spotifyTokenExpiry = Date().addingTimeInterval(TimeInterval(token.expires_in))
                   self.syncUserWithBackend { _ in }
                  completion(true)
                   // Ensure backend is in sync after refresh
                 case .failure(let error):
                     print("Refresh FAILED:", error.localizedDescription)
                     completion(false)
                 }
             }
     }

  // MARK: - Auto Get Valid Token
      func getValidAccessToken(completion: @escaping (String?) -> Void) {

          // If token expired → refresh
          if let expiry = spotifyTokenExpiry, expiry < Date() {
              print("Access Token Expired → Refreshing…")
              return refreshAccessToken { success in
                  completion(success ? KeychainService.shared.load(key: "spotify_access_token") : nil)
              }
          }

          // If access token exists and valid
          if let token = KeychainService.shared.load(key: "spotify_access_token") {
              return completion(token)
          }

          // If missing → try refresh
          refreshAccessToken { success in
              completion(success ? KeychainService.shared.load(key: "spotify_access_token") : nil)
          }
      }


  // MARK: - Backend Sync
    private func syncUserWithBackend(completion: @escaping (Bool) -> Void) {
        getValidAccessToken { token in
            guard let token = token else { completion(false); return }

          let headers: HTTPHeaders = [
                     "Authorization": "Bearer \(token)"
                 ]

          
          // Get Spotify Profile
                AF.request("https://api.spotify.com/v1/me", headers: headers).responseDecodable(of: SpotifyProfile.self) { response in

                        guard let profile = response.value else {
                            print("Spotify profile error:", response.error ?? "Unknown")
                            completion(false)
                            return
                        }

                        let body: [String: Any] = [
                            "email": profile.email ?? "",
                            "id": profile.id ?? "",
                            "display_name": profile.display_name ?? "User"
                        ]

                        // Send to Backend
                        AF.request(Host + "auth/spotify",method: .post,parameters: body,encoding: JSONEncoding.default).responseDecodable(of: BackendUserResponse.self) { response in

                                guard let user = response.value else {
                                    print("Backend sync failed:", response.error ?? "Unknown")
                                    completion(false)
                                    return
                                }
                          print(user.user_id ?? 0,"User ID is ")
                                userId = user.user_id ?? 0
                                completion(true)
                            }
                    }
            }
    }


  // Reusable Auth API call
  // - Parameters:
  //   - endpoint: API endpoint
  //   - parameters: key-value parameters from VC
  //   - method: GET / POST / PUT / DELETE
  //   - completion: returns User object or error
  //    func callAuthAPI(endpoint: String,parameters: [String: Any]? = nil,method: HTTPMethod = .post,completion: @escaping (Result<UserObject, AFError>) -> Void) {
  //
  //        APIManager.shared.request(endpoint: endpoint,method: method, parameters: parameters,completion: completion)
  //    }
}


