//
//  UserDefaultManager.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation

final class UserDefaultsManager {

    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard

    private init() {}

    // MARK: - Basic Setters
    func set(_ value: Any?, forKey key: String) {
        defaults.setValue(value, forKey: key)
        defaults.synchronize()
    }

    func getValue(forKey key: String) -> Any? {
        return defaults.value(forKey: key)
    }

    func setBool(_ value: Bool, forKey key: String) {
        defaults.set(value, forKey: key)
    }

    func getBool(forKey key: String) -> Bool {
        return defaults.bool(forKey: key)
    }

    func setInt(_ value: Int, forKey key: String) {
        defaults.set(value, forKey: key)
    }

    func getInt(forKey key: String) -> Int {
        return defaults.integer(forKey: key)
    }

    func removeValue(forKey key: String) {
        defaults.removeObject(forKey: key)
    }

    // MARK: - Codable Support
    func saveObject<T: Codable>(_ object: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(object) {
            defaults.set(data, forKey: key)
        } else {
            Utility.printDebug("Error encoding object: \(object)")
        }
    }

    func getObject<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - Clear All
    func clearAll() {
        defaults.dictionaryRepresentation().forEach { defaults.removeObject(forKey: $0.key) }
    }
}

//UserDefaultsManager.shared.saveObject(user, forKey: "loggedUser")
//
//let loggedUser = UserDefaultsManager.shared.getObject(UserObject.self, forKey: "loggedUser")
//UserDefaultsManager.shared.clearAll()
