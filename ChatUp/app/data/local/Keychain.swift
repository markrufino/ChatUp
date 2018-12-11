//
//  Keychain.swift
//  StarterKit
//
//  Created by Mark on 18/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import KeychainSwift

class Keychain: KeychainSwift {
    
    enum Keys: String {
        case loginToken
		case fcmToken
    }
    
    override init() {
        super.init(keyPrefix: Config.shared.kNamespace)
    }
    
    var apiAccessToken: String? {
        get {
            return self.get(Keys.loginToken.rawValue)
        }
        set {
            guard let k = newValue else {
                self.delete(Keys.loginToken.rawValue)
                return
            }
            self.set(k, forKey: Keys.loginToken.rawValue)
        }
    }

	var fcmToken: String? {
		get {
			return self.get(Keys.fcmToken.rawValue)
		}
		set {
			guard let k = newValue else {
				self.delete(Keys.fcmToken.rawValue)
				return
			}
			self.set(k, forKey: Keys.fcmToken.rawValue)
		}
	}
    
}
