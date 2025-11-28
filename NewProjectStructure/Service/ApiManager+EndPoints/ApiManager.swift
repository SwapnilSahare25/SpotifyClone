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
    private let baseURL = "https://api.yourdomain.com/"
    
    private var defaultHeaders: HTTPHeaders {
        let headers: HTTPHeaders = [
              "Accept": "application/json",
              "Content-Type": "application/json"
          ]
          // Add auth token if available
//          if let token = UserDefaults.standard.string(forKey: "authToken") {
//              headers.add(name: "Authorization", value: "Bearer \(token)")
//          }
          return headers
      }
    
    
    
    //Alamofire
    func request<T: Codable>(endpoint: String,method: HTTPMethod = .get,parameters: Parameters? = nil,headers: HTTPHeaders? = nil,encoding: ParameterEncoding = JSONEncoding.default,completion: @escaping (Result<T, AFError>) -> Void) {
        
        let url = baseURL + endpoint
        let requestHeaders = headers ?? defaultHeaders
        
        // Print URL, headers, and parameters
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
                    completion(.success(data))
                case .failure(let error):
                    print(" Error: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
   
    
    // URL Session
    // Generic GET request
       func getRequest(url: String, headers: [String: String]? = nil, completion: @escaping (Result<Data, Error>) -> Void) {

           guard let url = URL(string: url) else {
               completion(.failure(NSError(domain: "Invalid URL", code: 0)))
               return
           }

           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           headers?.forEach { key, value in
               request.setValue(value, forHTTPHeaderField: key)
           }

           URLSession.shared.dataTask(with: request) { data, response, error in
               DispatchQueue.main.async {
                   if let error = error {
                       completion(.failure(error))
                   } else if let data = data {
                       completion(.success(data))
                   } else {
                       completion(.failure(NSError(domain: "No data received", code: 0)))
                   }
               }
           }.resume()
       }
    
    // Generic POST request
       func postRequest(url: String, parameters: [String: Any], headers: [String: String]? = nil, completion: @escaping (Result<Data, Error>) -> Void) {

           guard let url = URL(string: url) else {
               completion(.failure(NSError(domain: "Invalid URL", code: 0)))
               return
           }

           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           headers?.forEach { key, value in
               request.setValue(value, forHTTPHeaderField: key)
           }

           do {
               request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
           } catch {
               completion(.failure(error))
               return
           }

           URLSession.shared.dataTask(with: request) { data, response, error in
               DispatchQueue.main.async {
                   if let error = error {
                       completion(.failure(error))
                   } else if let data = data {
                       completion(.success(data))
                   } else {
                       completion(.failure(NSError(domain: "No data received", code: 0)))
                   }
               }
           }.resume()
       }
}
