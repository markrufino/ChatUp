//
//  Provider+refreshTokenAndRetry.swift
//  StarterKit
//
//  Created by Mark on 02/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

extension Provider {

	func requestTokenAndRetry(target: API, keychain: Keychain = Keychain(), handler: @escaping ((ApiError?) -> Void)) {
		self.request(.refreshToken) { (result) in
			switch result {
			case .success(let value):
				if let header = value.response?.allHeaderFields {
					if let newAccessToken = header[HeaderKeys.AUTHORIZATION] {
						keychain.apiAccessToken = newAccessToken as? String
					}
					self.request(target: target, handler: handler)
				}
			case .failure(let error):
				guard case .statusCode(let errorResponse) = error else {
					handler(ApiError(message: "Non-Status Code Error"))
					break
				}

				if let providerError = try? errorResponse.map(ApiError.self, using: JSONDecoder.snakeCaseDecoder) {
					handler(providerError)
				}
			}
		}
	}
    
    func refreshTokenAndRetry<D: Decodable>(target: API, keychain: Keychain = Keychain(), handler: @escaping RequestDecodableCompletion<D>) {
		self.request(.refreshToken) { (result) in
			switch result {
			case .success(let value):
				if let header = value.response?.allHeaderFields {
					if let newAccessToken = header[HeaderKeys.AUTHORIZATION] {
						keychain.apiAccessToken = newAccessToken as? String
					}
					self.requestDecodable(target: target, handler: handler)
				}
			case .failure(let error):
				guard case .statusCode(let errorResponse) = error else {
					handler(ResultType<D>.failed(ApiError(message: "Non-Status Code Error")))
					break
				}

				if let providerError = try? errorResponse.map(ApiError.self, using: JSONDecoder.snakeCaseDecoder) {
					handler(ResultType<D>.failed(providerError))
				}
			}
		}
    }
    
}
