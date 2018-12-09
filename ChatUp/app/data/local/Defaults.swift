//
//  Defaults.swift
//  StarterKit
//
//  Created by Mark on 18/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

class Defaults {
    
    private let internalUserDefaults = UserDefaults.standard
    
    enum Keys: String {
        case hasInitializedFirstLaunch
        
        var namespaced: String {
            return Config.shared.kNamespace + "." + self.rawValue
        }
    }
    
    init() {
    }
    
    var hasInitializedFirstLaunch: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.hasInitializedFirstLaunch.namespaced)
        }
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasInitializedFirstLaunch.namespaced)
        }
    }
    
}
