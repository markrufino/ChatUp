//
//  APIAuthType.swift
//  StarterKit
//
//  Created by Mark on 24/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

enum APIAuthType {
    
    case none
    case accessToken
    
    var key: String {
        switch self {
        case .none:
            return ""
        case .accessToken:
            return "Authorization"
        }
    }
    
    var value: String {
        switch self {
        case .none:
            return ""
        case .accessToken:
            let keychain = Keychain()
            return keychain.apiAccessToken ?? ""
        }
    }
}


