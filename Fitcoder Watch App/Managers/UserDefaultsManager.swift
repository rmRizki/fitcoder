//
//  UserDefaultsManager.swift
//  Fitcoder Watch App
//
//  Created by Rizki Maulana on 26/05/24.
//

import Foundation

class UserDefaultsManager {
    private let defaults = UserDefaults.standard
    private let lastTimeCommitKey = "lastTimeCommit"
    private let shaFromFileKey = "shaFromFile"
    
    private func set(value: Any?, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    private func value(forKey key: String) -> Any? {
        return defaults.value(forKey: key)
    }
    
    var lastTimeCommit: Date? {
        get {
            return value(forKey: lastTimeCommitKey) as? Date
        }
        set {
            set(value: newValue, forKey: lastTimeCommitKey)
        }
    }
    
    var shaFromFile: String? {
        get {
            return value(forKey: shaFromFileKey) as? String
        }
        set {
            set(value: newValue, forKey: shaFromFileKey)
        }
    }
}
