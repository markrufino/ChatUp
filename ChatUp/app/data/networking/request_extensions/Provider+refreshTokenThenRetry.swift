//
//  Provider+refreshTokenThenRetry.swift
//  ChatUp
//
//  Created by Mark on 13/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import Moya

extension Provider {

	func refreshTokenThenRetry(_ target: API, decoder: JSONDecoder, completion: @escaping ((ApiError?) -> Void)) {
		self.request(.refreshToken) { (result) in
			switch result {
			case .success(let response):

				do {
					let successfulResponse = try response.filterSuccessfulStatusCodes()
					if let header = successfulResponse.response?.allHeaderFields {
						if let newAccessToken = header[HeaderKeys.AUTHORIZATION] {
							Keychain().apiAccessToken = newAccessToken as? String
							self.requestPlain(target, decoder: decoder, completion: completion)
						}
					}
					// FALLBACK
				} catch {

					guard let e = error as? MoyaError else {
						let apiError = ApiError.init(message: error.localizedDescription)
						completion(apiError)
						break
					}

					guard case .statusCode(let errorResponse) = e else {
						let apiError = ApiError.init(message: e.localizedDescription)
						completion(apiError)
						break
					}

					guard let mappedApiError = try? errorResponse.map(ApiError.self, using: decoder) else {
						let apiError = ApiError.init(message: "Unable to map errorResponse to ApiError")
						completion(apiError)
						break
					}

					completion(mappedApiError)

				}

			case .failure(let error):
				let apiError = ApiError.init(message: error.localizedDescription)
				completion(apiError)
			}
		}
	}

	func refreshTokenThenRetry<D: Decodable>(_ target: API, decoder: JSONDecoder, completion: @escaping RequestJSONCompletion<D>) {
		self.request(.refreshToken) { (result) in
			switch result {
			case .success(let response):

				do {
					let successfulResponse = try response.filterSuccessfulStatusCodes()
					if let header = successfulResponse.response?.allHeaderFields {
						if let newAccessToken = header[HeaderKeys.AUTHORIZATION] {
							Keychain().apiAccessToken = newAccessToken as? String
							self.requestJSON(target, decoder: decoder, completion: completion)
						}
					}
					// FALLBACK
				} catch {

					guard let e = error as? MoyaError else {
						let apiError = ApiError.init(message: error.localizedDescription)
						let requestResult = RequestResult<D>.error(apiError)
						completion(requestResult)
						break
					}

					guard case .statusCode(let errorResponse) = e else {
						let apiError = ApiError.init(message: e.localizedDescription)
						let requestResult = RequestResult<D>.error(apiError)
						completion(requestResult)
						break
					}

					guard let mappedApiError = try? errorResponse.map(ApiError.self, using: decoder) else {
						let apiError = ApiError.init(message: "Unable to map errorResponse to ApiError")
						let requestResult = RequestResult<D>.error(apiError)
						completion(requestResult)
						break
					}

					let requestResult = RequestResult<D>.error(mappedApiError)
					completion(requestResult)

				}

			case .failure(let error):
				let apiError = ApiError.init(message: error.localizedDescription)
				let requestResult = RequestResult<D>.error(apiError)
				completion(requestResult)
			}
		}
    }
    
}
