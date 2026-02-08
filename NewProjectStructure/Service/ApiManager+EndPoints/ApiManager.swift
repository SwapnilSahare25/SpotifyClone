//
//  ApiManager.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation
import Alamofire

class APIManager {
    
    static let shared = APIManager()
    private init() {}
    //private let baseURL = "http://127.0.0.1:5001/"
  private let baseURL = "http://192.168.1.33:5001/"
    var currentToken: String?

  private func createAuthenticatedHeaders(with token: String? = nil) -> HTTPHeaders {

    var defaultHeaders: HTTPHeaders = [
      "Accept": "application/json",
      "Content-Type": "application/json"
    ]
    if let token = token{
      defaultHeaders.add(name: "Authorization", value: "Bearer \(token)")
    }

    return defaultHeaders
  }


//    
    
    //Alamofire
  func request<T: Decodable>(endpoint: String,method: HTTPMethod = .get,parameters: Parameters? = nil,encoding: ParameterEncoding = JSONEncoding.default,onSuccess: @escaping (T) -> Void,
                             onFailure: @escaping (String) -> Void) {

    let url = baseURL + endpoint
    UserAuthenticationService.shared.getValidAccessToken { accessToken in

      if let token = accessToken{

        let requestHeaders = self.createAuthenticatedHeaders(with: token)

        print(" URL: \(url)")
        print(" Method: \(method.rawValue)")
        print(" Headers: \(requestHeaders)")

        if let params = parameters {
          print(" Parameters: \(params)")
        } else {
          print(" Parameters: None")
        }

        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: requestHeaders)
          .validate()
          .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
              print(" Response: \(data)")
              onSuccess(data)
            case .failure(let error):
              print(" Error: \(error)")
              onFailure(error.localizedDescription)
            }
          }

      }else{
        print("No valid access token available")
      }
    }


  }
    
   
    
    // URL Session
    // Generic GET request
//       func getRequest(url: String, headers: [String: String]? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
//
//           guard let url = URL(string: url) else {
//               completion(.failure(NSError(domain: "Invalid URL", code: 0)))
//               return
//           }
//
//           var request = URLRequest(url: url)
//           request.httpMethod = "GET"
//           headers?.forEach { key, value in
//               request.setValue(value, forHTTPHeaderField: key)
//           }
//
//           URLSession.shared.dataTask(with: request) { data, response, error in
//               DispatchQueue.main.async {
//                   if let error = error {
//                       completion(.failure(error))
//                   } else if let data = data {
//                       completion(.success(data))
//                   } else {
//                       completion(.failure(NSError(domain: "No data received", code: 0)))
//                   }
//               }
//           }.resume()
//       }
//    
//    // Generic POST request
//       func postRequest(url: String, parameters: [String: Any], headers: [String: String]? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
//
//           guard let url = URL(string: url) else {
//               completion(.failure(NSError(domain: "Invalid URL", code: 0)))
//               return
//           }
//
//           var request = URLRequest(url: url)
//           request.httpMethod = "POST"
//           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//           headers?.forEach { key, value in
//               request.setValue(value, forHTTPHeaderField: key)
//           }
//
//           do {
//               request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//           } catch {
//               completion(.failure(error))
//               return
//           }
//
//           URLSession.shared.dataTask(with: request) { data, response, error in
//               DispatchQueue.main.async {
//                   if let error = error {
//                       completion(.failure(error))
//                   } else if let data = data {
//                       completion(.success(data))
//                   } else {
//                       completion(.failure(NSError(domain: "No data received", code: 0)))
//                   }
//               }
//           }.resume()
//       }
}


//    private var defaultHeaders: HTTPHeaders {
//
//      var headers: HTTPHeaders = [
//              "Accept": "application/json",
//              "Content-Type": "application/json"
//          ]
//      // Add auth token if available
//        if let token = currentToken{
//          headers.add(name: "Authorization:", value: "Bearer \(token)")
//      }
//          return headers
//      }
//
