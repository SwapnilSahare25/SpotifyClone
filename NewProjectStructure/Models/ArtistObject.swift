//
//  ArtistObject.swift
//  NewProjectStructure
//
//  Created by Swapnil on 04/02/26.
//

import Foundation

// MARK: - Welcome
struct ArtistObject: Codable {
    let albums: [AlbumObject]?
    let followers: String?
    let id: Int?
    let image: String?
    let name: String?
    let popularTracks: [Item]?
    let relatedArtists: [Artist]?
  let isLiked: Bool?

    enum CodingKeys: String, CodingKey {
        case albums, followers, id, image, name
        case popularTracks = "popular_tracks"
        case relatedArtists = "related_artists"
      case isLiked = "is_liked"
    }
}

//// MARK: - Album
//struct Album: Codable {
//    let artist, description: String?
//    let id: Int?
//    let image: String?
//    let subtitle, title, type: String?
//}

//// MARK: - PopularTrack
//struct PopularTrack: Codable {
//    let album, artist, description, duration: String?
//    let id: Int?
//    let image: String?
//    let title, type: String?
//    let url: String?
//    let play_count: Int64?
//}

//// MARK: - RelatedArtist
//struct RelatedArtist: Codable {
//    let id: Int?
//    let image: String?
//    let name, type: String?
//}


enum ArtistSectionType {
  case header(ArtistObject)
  case popularTracks([Item])
  case album([AlbumObject])
  case relatedArtist([Artist])
  case none
}
//struct ArtistSectionsArray {
//  var sectionHeaderTitleStr: String = ""
//  var artistSectionType: ArtistSectionType = .none
//  var headerHeight: CGFloat = 50*DeviceMultiplier
//
//}

@MainActor
struct ArtistSectionsArray {
    var sectionHeaderTitleStr: String
    var artistSectionType: ArtistSectionType
    var headerHeight: CGFloat

    // HIG Compliant init. Eliminates strict concurrency/MainActor warnings.
    init(sectionHeaderTitleStr: String = "",artistSectionType: ArtistSectionType = .none,headerHeight: CGFloat? = nil) {
        self.sectionHeaderTitleStr = sectionHeaderTitleStr
        self.artistSectionType = artistSectionType
        // Defers computing DeviceMultiplier until struct allocation inside MainActor
        self.headerHeight = headerHeight ?? (50*DeviceMultiplier)
    }
}
