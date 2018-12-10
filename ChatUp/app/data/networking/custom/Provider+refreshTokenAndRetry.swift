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

	func requestTokenAndRetry(target: API, keychain: Keychain = Keychain(), plainHandler: @escaping ((ApiError?) -> Void)) {
		self.requestDecodable(target: .refreshToken) { (r: ResultType<RefreshTokenResponse>) in
			switch r {

			case .success(let response):
				keychain.apiAccessToken = response.refreshToken
				self.requestPlain(target: target, handler: plainHandler)

			case .failed(let error):
				print(error.localizedDescription)

			}
		}
	}
    
    func refreshTokenAndRetry<D: Decodable>(target: API, keychain: Keychain = Keychain(), decodableHandler: @escaping RequestDecodableCompletion<D>) {
        self.requestDecodable(target: .refreshToken) { (r: ResultType<RefreshTokenResponse>) in
            switch r {
                
            case .success(let response):
                keychain.apiAccessToken = response.refreshToken
                self.requestDecodable(target: target, handler: decodableHandler)
                
            case .failed(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
}
