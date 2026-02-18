//
//  LikedSongsObject.swift
//  NewProjectStructure
//
//  Created by Swapnil on 30/01/26.
//

import Foundation

// MARK: - Welcome
struct LikedSongsObject: Codable {
    let id: String?
    let image: String?
    let title: String?
    let tracks: Tracks?
    let type: String?
}

// MARK: - Tracks
struct Tracks: Codable {
    let items: [Item]?
    let total: Int?
}
// MARK: - Welcome
struct LikeObject: Codable {
    let isLiked: Bool?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case isLiked = "is_liked"
        case message
    }
}
