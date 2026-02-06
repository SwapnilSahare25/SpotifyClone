//
//  AlbumObject.swift
//  NewProjectStructure
//
//  Created by Swapnil on 04/02/26.
//

import Foundation


struct AlbumObject: Codable {
  let artist: String?
  let id: Int?
  let image: String?
  let title: String?
  let tracks: Tracks?
  let type: String?
  let description: String?
  let subtitle: String?
  let year: Int?
  let totalDuration: String?

  
  enum CodingKeys: String, CodingKey {
      case artist
      case id
      case image
      case title
      case tracks
      case type
      case description
      case subtitle
      case year
      case totalDuration = "total_duration"
  }

}

