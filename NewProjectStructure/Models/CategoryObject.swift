//
//  CategoryObject.swift
//  NewProjectStructure
//
//  Created by Swapnil on 20/02/26.
//

import Foundation


struct CategoryObject: Codable {
    let color: String?
    let id: Int?
    let image: String?
    let items: [Item]?
    let name: String?
}
