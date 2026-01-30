//
//  SongsObject.swift
//  NewProjectStructure
//
//  Created by Swapnil on 30/01/26.
//

import Foundation

// MARK: - Welcome
struct SongsObject: Codable {
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
