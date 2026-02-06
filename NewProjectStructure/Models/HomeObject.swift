//
//  HomeObject.swift
//  NewProjectStructure
//
//  Created by Swapnil on 23/12/25.
//

import Foundation


struct HomeObject: Codable {

  let gridItems: [GridItem]?
  let newRelease: NewRelease?
  let sections: [SectionObject]?

  enum CodingKeys: String, CodingKey {
    case gridItems = "grid_items"
    case newRelease = "new_release"
    case sections
  }
}

// MARK: - GridItem
struct GridItem: Codable {
  let id: Int?
  let image: String?
  let pinned: Bool?
  let title, type, album, artist: String?
  let duration: String?
  let url: String?
  let description: String?
  let owner: String?
  let songCount: Int?
  let subtitle: String?

  enum CodingKeys: String, CodingKey {
    case id, image, pinned, title, type, album, artist, duration, url, description, owner
    case songCount = "song_count"
    case subtitle
  }
}
// MARK: - NewRelease
struct NewRelease: Codable {
  let artist: Artist?
  let content: Content?
  let type: String?
  let id: Int?
}

// MARK: - Artist
struct Artist: Codable {
  let image: String?
  let name: String?
  let id: Int?
  let type: String?
}

// MARK: - Content
struct Content: Codable {
  let artist: String?
  let id: Int?
  let image: String?
  let subtitle, title: String?
  let type: String?
}
// MARK: - Section
struct SectionObject: Codable {
  let id: String?
  let items: [Item]?
  let title, image,type: String?

  enum CodingKeys:String, CodingKey {
    case id, items, title, image, type
  }
}

// MARK: - Item
struct Item: Codable {
  let description: String?
  let id: Int?
  let image: String?
  let owner: String?
  let songCount: Int?
  let subtitle, title: String?
  let type: String?
  let artist, name: String?
  let color: String?
  let pinned: Bool?
  let album: String?
  let duration: String?
  let url: String?
  let playCount: Int64?

  enum CodingKeys: String, CodingKey {
    case description, id, image, owner
    case songCount = "song_count"
    case subtitle, title, type, artist, name, color, pinned, album, duration, url
    case playCount = "play_count"
  }
}
enum HomeSectionType {
  case quickAccess([GridItem])
  case newRelease(NewRelease)
  case horizontalShelf(SectionObject)
  case circularArtistShelf(SectionObject)
  case none
}


struct HomeSectionsArray {
  var sectionHeaderTitleStr: String = ""
  var sectionHeaderIcon: String = ""
  var sectionHeaderSubtitle:String = ""
  var isRequiredIconAndSubtitle: Bool = false
  var isRequiredHeader: Bool = true
  var homeSectionType: HomeSectionType = .none
  var headerHeight: CGFloat = 0
}
