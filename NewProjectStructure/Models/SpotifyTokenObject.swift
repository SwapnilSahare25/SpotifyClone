//
//  TokenObject.swift
//  NewProjectStructure
//
//  Created by Swapnil on 28/11/25.
//

import Foundation


// Spotify Token Model
struct SpotifyTokenObject: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
    let refresh_token: String?

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.access_token, forKey: .access_token)
    try container.encode(self.token_type, forKey: .token_type)
    try container.encode(self.expires_in, forKey: .expires_in)
    try container.encodeIfPresent(self.refresh_token, forKey: .refresh_token)
  }

  enum CodingKeys: CodingKey {
    case access_token
    case token_type
    case expires_in
    case refresh_token
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.access_token = try container.decode(String.self, forKey: .access_token)
    self.token_type = try container.decode(String.self, forKey: .token_type)
    self.expires_in = try container.decode(Int.self, forKey: .expires_in)
    self.refresh_token = try container.decodeIfPresent(String.self, forKey: .refresh_token)


  }
}


struct SpotifyProfile: Decodable {
    let id: String?
    let email: String?
    let display_name: String?
}
struct BackendUserResponse: Decodable {
    let user_id: Int? 
}
