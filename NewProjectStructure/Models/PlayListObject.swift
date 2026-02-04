//
//  PlayListObject.swift
//  NewProjectStructure
//
//  Created by Swapnil on 04/02/26.
//

import Foundation

// MARK: - Welcome
struct PlayListObject: Codable {
    let description: String?
    let id: Int?
    let image: String?
    let owner: String?
    let songCount: Int?
    let subtitle, title: String?
    let tracks: Tracks?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case description, id, image, owner
        case songCount = "song_count"
        case subtitle, title, tracks, type
    }
}
