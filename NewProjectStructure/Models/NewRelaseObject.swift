//
//  NewRelaseObject.swift
//  NewProjectStructure
//
//  Created by Swapnil on 11/12/25.
//

//import Foundation
//
//
//struct NewRelaseObject: Codable {
//  
//  let albums: Albums?
//
//
//  func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: CodingKeys.self)
//    try container.encodeIfPresent(self.albums, forKey: .albums)
//  }
//
//  enum CodingKeys: CodingKey {
//    case albums
//  }
//
//  init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    self.albums = try container.decodeIfPresent(Albums.self, forKey: .albums)
//  }
//
//}
//// MARK: - Albums
//struct Albums: Codable {
//    let href: String?
//    let items: [Item]?
//    let limit: Int?
//    let next: String?
//    let offset: Int?
//    let previous: Int?
//    let total: Int?
//
//  func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: CodingKeys.self)
//    try container.encodeIfPresent(self.href, forKey: .href)
//    try container.encodeIfPresent(self.items, forKey: .items)
//    try container.encodeIfPresent(self.limit, forKey: .limit)
//    try container.encodeIfPresent(self.next, forKey: .next)
//    try container.encodeIfPresent(self.offset, forKey: .offset)
//    try container.encodeIfPresent(self.previous, forKey: .previous)
//    try container.encodeIfPresent(self.total, forKey: .total)
//  }
//
//  enum CodingKeys: CodingKey {
//    case href
//    case items
//    case limit
//    case next
//    case offset
//    case previous
//    case total
//  }
//
//  init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    self.href = try container.decodeIfPresent(String.self, forKey: .href)
//    self.items = try container.decodeIfPresent([Item].self, forKey: .items)
//    self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
//    self.next = try container.decodeIfPresent(String.self, forKey: .next)
//    self.offset = try container.decodeIfPresent(Int.self, forKey: .offset)
//    self.previous = try container.decodeIfPresent(Int.self, forKey: .previous)
//    self.total = try container.decodeIfPresent(Int.self, forKey: .total)
//  }
//}
//
//// MARK: - Item
//struct Item: Codable {
//    let albumType: String?
//    let artists: [Artist]?
//    let availableMarkets: [String]?
//    let externalUrls: ExternalUrls?
//    let href: String?
//    let id: String?
//    let images: [Image]?
//    let name, releaseDate, releaseDatePrecision: String?
//    let totalTracks: Int?
//    let type, uri: String?
//
//    enum CodingKeys: String, CodingKey {
//        case albumType = "album_type"
//        case artists
//        case availableMarkets = "available_markets"
//        case externalUrls = "external_urls"
//        case href, id, images, name
//        case releaseDate = "release_date"
//        case releaseDatePrecision = "release_date_precision"
//        case totalTracks = "total_tracks"
//        case type, uri
//    }
//
//  func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: CodingKeys.self)
//    try container.encodeIfPresent(self.albumType, forKey: .albumType)
//    try container.encodeIfPresent(self.artists, forKey: .artists)
//    try container.encodeIfPresent(self.availableMarkets, forKey: .availableMarkets)
//    try container.encodeIfPresent(self.externalUrls, forKey: .externalUrls)
//    try container.encodeIfPresent(self.href, forKey: .href)
//    try container.encodeIfPresent(self.id, forKey: .id)
//    try container.encodeIfPresent(self.images, forKey: .images)
//    try container.encodeIfPresent(self.name, forKey: .name)
//    try container.encodeIfPresent(self.releaseDate, forKey: .releaseDate)
//    try container.encodeIfPresent(self.releaseDatePrecision, forKey: .releaseDatePrecision)
//    try container.encodeIfPresent(self.totalTracks, forKey: .totalTracks)
//    try container.encodeIfPresent(self.type, forKey: .type)
//    try container.encodeIfPresent(self.uri, forKey: .uri)
//  }
//
//  init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    self.albumType = try container.decodeIfPresent(String.self, forKey: .albumType)
//    self.artists = try container.decodeIfPresent([Artist].self, forKey: .artists)
//    self.availableMarkets = try container.decodeIfPresent([String].self, forKey: .availableMarkets)
//    self.externalUrls = try container.decodeIfPresent(ExternalUrls.self, forKey: .externalUrls)
//    self.href = try container.decodeIfPresent(String.self, forKey: .href)
//    self.id = try container.decodeIfPresent(String.self, forKey: .id)
//    self.images = try container.decodeIfPresent([Image].self, forKey: .images)
//    self.name = try container.decodeIfPresent(String.self, forKey: .name)
//    self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
//    self.releaseDatePrecision = try container.decodeIfPresent(String.self, forKey: .releaseDatePrecision)
//    self.totalTracks = try container.decodeIfPresent(Int.self, forKey: .totalTracks)
//    self.type = try container.decodeIfPresent(String.self, forKey: .type)
//    self.uri = try container.decodeIfPresent(String.self, forKey: .uri)
//  }
//}
//
//// MARK: - Artist
//struct Artist: Codable {
//    let externalUrls: ExternalUrls?
//    let href: String?
//    let id, name, type, uri: String?
//
//    enum CodingKeys: String, CodingKey {
//        case externalUrls = "external_urls"
//        case href, id, name, type, uri
//    }
//
//  func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: CodingKeys.self)
//    try container.encodeIfPresent(self.externalUrls, forKey: .externalUrls)
//    try container.encodeIfPresent(self.href, forKey: .href)
//    try container.encodeIfPresent(self.id, forKey: .id)
//    try container.encodeIfPresent(self.name, forKey: .name)
//    try container.encodeIfPresent(self.type, forKey: .type)
//    try container.encodeIfPresent(self.uri, forKey: .uri)
//  }
//
//  init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    self.externalUrls = try container.decodeIfPresent(ExternalUrls.self, forKey: .externalUrls)
//    self.href = try container.decodeIfPresent(String.self, forKey: .href)
//    self.id = try container.decodeIfPresent(String.self, forKey: .id)
//    self.name = try container.decodeIfPresent(String.self, forKey: .name)
//    self.type = try container.decodeIfPresent(String.self, forKey: .type)
//    self.uri = try container.decodeIfPresent(String.self, forKey: .uri)
//  }
//}
