//
//  Defaults.swift
//  StarterKit
//
//  Created by Mark on 18/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

class Defaults {
    
    private let internalUserDefaults = UserDefaults(suiteName: Config.shared.kNamespace)
    
    enum Keys: String {
        case hasInitializedFirstLaunch
    }
    
    init() {
    }
    
    var hasInitializedFirstLaunch: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.hasInitializedFirstLaunch.rawValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasInitializedFirstLaunch.rawValue)
        }
    }
    
}
