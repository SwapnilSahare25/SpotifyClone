//
//  KeychainService.swift
//  NewProjectStructure
//
//  Created by Swapnil on 09/12/25.
//

import Foundation
import Security

class KeychainService {

    static let shared = KeychainService()
    private init() {}

    // MARK: - Save
    func save(key: String, value: String) {
        let data = value.data(using: .utf8)!

        // Delete existing value
        let deleteQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,kSecAttrAccount as String: key]
        SecItemDelete(deleteQuery as CFDictionary)

        // Add new value
        let addQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,kSecAttrAccount as String: key,kSecValueData as String: data]
        SecItemAdd(addQuery as CFDictionary, nil)
    }

    // MARK: - Load
    func load(key: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,kSecAttrAccount as String: key,kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecSuccess,
           let data = item as? Data,
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        return nil
    }

    // MARK: - Delete
    func delete(key: String) {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,kSecAttrAccount as String: key]
        SecItemDelete(query as CFDictionary)
    }
}
