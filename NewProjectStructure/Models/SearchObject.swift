//
//  SearchObject.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/12/25.
//

import Foundation


struct SearchObject: Codable {

  let sections: [SectionObject]?
  let title, type: String?


}

enum SearchType {
  case topGenres(SectionObject)
  case browseAll(SectionObject)
  case none
}

struct SearchLayoutObject {
  var headerTitle:String = ""
  var searcType:SearchType = .none
}



//// MARK: - Section
//struct Section: Codable {
//    let items: [Item]?
//    let title, type: String?
//}

//// MARK: - Item
//struct Item: Codable {
//    let color: String?
//    let id: Int?
//    let image: String?
//    let name: String?
//}
