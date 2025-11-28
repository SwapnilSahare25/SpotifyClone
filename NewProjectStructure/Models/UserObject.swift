//
//  UserObject.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation

struct UserObject: Codable {
    
    var userId: String?
    var name: String?
    var email: String?
    var phone: String?
    var token: String?
    var message: String? // For API messages


  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.userId, forKey: .userId)
    try container.encodeIfPresent(self.name, forKey: .name)
    try container.encodeIfPresent(self.email, forKey: .email)
    try container.encodeIfPresent(self.phone, forKey: .phone)
    try container.encodeIfPresent(self.token, forKey: .token)
    try container.encodeIfPresent(self.message, forKey: .message)
  }

  enum CodingKeys: CodingKey {
    case userId
    case name
    case email
    case phone
    case token
    case message
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.userId = try container.decode(String.self, forKey: .userId)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
    self.email = try container.decodeIfPresent(String.self, forKey: .email)
    self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
    self.token = try container.decodeIfPresent(String.self, forKey: .token)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }

}
