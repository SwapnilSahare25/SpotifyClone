//
//  Endpoints.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation

struct Endpoints {


    static func deleteUser(id: String) -> String {
        return "/auth/delete/\(id)"
    }

  static func getCurrentUser() -> String {
    return "/me"
  }

  static func home() -> String {
    return "home"
  }
  static func search(q:String="", recent:Bool=false) -> String {
    return "search?q=\(q)&recent\(recent)"
  }
  static func getNewReleaseSongs(limit: Int = 10, offset: Int = 0) -> String {
    return "/browse/new-releases?limit=\(limit)&offset=\(offset)"
  }

  static func getAllFeaturedPlayList(limit: Int = 10, offset: Int = 0) -> String {
    return "/browse/featured-playlists?limit=\(limit)&offset=\(offset)"
  }



    static func productOptions(lang: String, currency: String) -> String {
        return "/product/configurable-options?lang=\(lang)&currencyCode=\(currency)"
    }
}
