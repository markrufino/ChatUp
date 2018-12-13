//
//  Provider+requestJSON.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/13/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import Moya

extension Provider {

	/// Use this request method for API's with JSON responses, usually GET stuff.
	func requestJSON<D: Decodable>(_ target: API, decoder: JSONDecoder = JSONDecoder.snakeCaseDecoder, completion: @escaping RequestJSONCompletion<D>) {

		self.request(target) { (result) in

			let requestResult: RequestResult<D>

			switch result {
			case .success(let response):
				do {
					let decodable = try response.filterSuccessfulStatusCodes().map(D.self, using: decoder)
					requestResult = RequestResult<D>.success(decodable)
				} catch {

					guard let e = error as? MoyaError else {
						let apiError = ApiError.init(message: error.localizedDescription)
						requestResult = RequestResult<D>.error(apiError)
						break
					}

					guard case .statusCode(let errorResponse) = e else {
						let apiError = ApiError.init(message: e.localizedDescription)
						requestResult = RequestResult<D>.error(apiError)
						break
					}

					if errorResponse.statusCode == 401 && target.needsToRefreshToken {
						self.refreshTokenThenRetry(target, decoder: decoder, completion: completion)
						return
					}

					guard let apiError = try? errorResponse.map(ApiError.self, using: decoder) else {
						let apiError = ApiError.init(message: "Unable to map errorResponse to ApiError")
						requestResult = RequestResult<D>.error(apiError)
						break
					}

					requestResult = RequestResult<D>.error(apiError)

				}
			case .failure(let error):
				let apiError = ApiError.init(message: error.localizedDescription)
				requestResult = RequestResult<D>.error(apiError)
			}

			completion(requestResult)

		}
	}

}
