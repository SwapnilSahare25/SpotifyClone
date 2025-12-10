//
//  UserObject.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation

// MARK: - Welcome
struct UserObject: Codable {
    let country, displayName, email: String?
    let explicitContent: ExplicitContent?
    let externalUrls: ExternalUrls?
    let followers: Followers?
    let href, id: String?
    let images: [Image]?
    let product, type, uri: String?

    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case explicitContent = "explicit_content"
        case externalUrls = "external_urls"
        case followers, href, id, images, product, type, uri
    }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.country, forKey: .country)
    try container.encodeIfPresent(self.displayName, forKey: .displayName)
    try container.encodeIfPresent(self.email, forKey: .email)
    try container.encodeIfPresent(self.explicitContent, forKey: .explicitContent)
    try container.encodeIfPresent(self.externalUrls, forKey: .externalUrls)
    try container.encodeIfPresent(self.followers, forKey: .followers)
    try container.encodeIfPresent(self.href, forKey: .href)
    try container.encodeIfPresent(self.id, forKey: .id)
    try container.encodeIfPresent(self.images, forKey: .images)
    try container.encodeIfPresent(self.product, forKey: .product)
    try container.encodeIfPresent(self.type, forKey: .type)
    try container.encodeIfPresent(self.uri, forKey: .uri)
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.country = try container.decodeIfPresent(String.self, forKey: .country)
    self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
    self.email = try container.decodeIfPresent(String.self, forKey: .email)
    self.explicitContent = try container.decodeIfPresent(ExplicitContent.self, forKey: .explicitContent)
    self.externalUrls = try container.decodeIfPresent(ExternalUrls.self, forKey: .externalUrls)
    self.followers = try container.decodeIfPresent(Followers.self, forKey: .followers)
    self.href = try container.decodeIfPresent(String.self, forKey: .href)
    self.id = try container.decodeIfPresent(String.self, forKey: .id)
    self.images = try container.decodeIfPresent([Image].self, forKey: .images)
    self.product = try container.decodeIfPresent(String.self, forKey: .product)
    self.type = try container.decodeIfPresent(String.self, forKey: .type)
    self.uri = try container.decodeIfPresent(String.self, forKey: .uri)
  }
}

// MARK: - ExplicitContent
struct ExplicitContent: Codable {
    let filterEnabled, filterLocked: Bool?

    enum CodingKeys: String, CodingKey {
        case filterEnabled = "filter_enabled"
        case filterLocked = "filter_locked"
    }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.filterEnabled, forKey: .filterEnabled)
    try container.encodeIfPresent(self.filterLocked, forKey: .filterLocked)
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.filterEnabled = try container.decodeIfPresent(Bool.self, forKey: .filterEnabled)
    self.filterLocked = try container.decodeIfPresent(Bool.self, forKey: .filterLocked)
  }
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String?

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.spotify, forKey: .spotify)
  }

  enum CodingKeys: CodingKey {
    case spotify
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.spotify = try container.decodeIfPresent(String.self, forKey: .spotify)
  }
}

// MARK: - Followers
struct Followers: Codable {
    let href: String?
    let total: Int?

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.href, forKey: .href)
    try container.encodeIfPresent(self.total, forKey: .total)
  }

  enum CodingKeys: CodingKey {
    case href
    case total
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.href = try container.decodeIfPresent(String.self, forKey: .href)
    self.total = try container.decodeIfPresent(Int.self, forKey: .total)
  }
}

// MARK: - Image
struct Image: Codable {
    let url: String?
    let height, width: Int?

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.url, forKey: .url)
    try container.encodeIfPresent(self.height, forKey: .height)
    try container.encodeIfPresent(self.width, forKey: .width)
  }

  enum CodingKeys: CodingKey {
    case url
    case height
    case width
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.url = try container.decodeIfPresent(String.self, forKey: .url)
    self.height = try container.decodeIfPresent(Int.self, forKey: .height)
    self.width = try container.decodeIfPresent(Int.self, forKey: .width)
  }
}
