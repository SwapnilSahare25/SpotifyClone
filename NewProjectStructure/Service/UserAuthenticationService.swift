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

class UserAuthenticationService {
    static let shared = UserAuthenticationService()
    private init() {}

  private var safariVC: SFSafariViewController?



  // Step 1: Get Authorization URL
      private func getAuthURL() -> URL? {
          let redirect = redirectUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
          let scopeEncoded = scopes.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

          let urlString = Host+"?response_type=code&client_id=\(spotifyClientID)&scope=\(scopeEncoded)&redirect_uri=\(redirect)"
          return URL(string: urlString)
      }

  // Step 2: Open Spotify login page in SFSafariViewController
     func login(from viewController: UIViewController) {
         guard let url = getAuthURL() else { return }
         safariVC = SFSafariViewController(url: url)
         viewController.present(safariVC!, animated: true)
     }

  func exchangeCodeForToken(code: String, completion: @escaping (Result<SpotifyTokenObject, AFError>) -> Void) {
      let url = "https://accounts.spotify.com/api/token"

      let params: [String: String] = [
          "grant_type": "authorization_code",
          "code": code,
          "redirect_uri": redirectUrl,
          "client_id": spotifyClientID,
          "client_secret": spotifyClientSecret
      ]

      let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]


    AF.request(url,method: .post,parameters: params,encoder: URLEncodedFormParameterEncoder.default,headers: headers).validate()
      .responseDecodable(of: SpotifyTokenObject.self) { response in

          completion(response.result)

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


