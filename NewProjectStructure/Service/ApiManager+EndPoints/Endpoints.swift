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


    static func productOptions(lang: String, currency: String) -> String {
        return "/product/configurable-options?lang=\(lang)&currencyCode=\(currency)"
    }
}
