//
//  Provider+refreshTokenAndRetry.swift
//  StarterKit
//
//  Created by Mark on 02/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct RefreshTokenResponse: Decodable {
    let refreshToken: String
}

extension Provider {
    
    func refreshTokenAndRetry<D: Decodable>(target: API, keychain: Keychain = Keychain(), handler: @escaping RequestDecodableCompletion<D>) {
        self.requestDecodable(target: .refreshToken) { (r: ResultType<RefreshTokenResponse>) in
            switch r {
                
            case .success(let response):
                keychain.apiAccessToken = response.refreshToken
                self.requestDecodable(target: target, handler: handler)
                
            case .failed(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
}
