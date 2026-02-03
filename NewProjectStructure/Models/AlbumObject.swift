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
    let type, year: String?
}

