//
//  Provider+requestPlain.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/13/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import Moya

extension Provider {

	/// Use this request method for API's with discardable responses, usually POST stuff.
	func requestPlain(_ target: API, decoder: JSONDecoder = JSONDecoder.snakeCaseDecoder, completion: @escaping (ApiError?) -> Void) {

		self.request(target) { (result) in

			let apiError: ApiError?

			switch result {
			case .success(let response):

				do {
					let _ = try response.filterSuccessfulStatusCodes()
					apiError = nil
				} catch {

					guard let e = error as? MoyaError else {
						apiError = ApiError.init(message: error.localizedDescription)
						break
					}

					guard case .statusCode(let errorResponse) = e else {
						apiError = ApiError.init(message: e.localizedDescription)
						break
					}

					if errorResponse.statusCode == 401 && target.needsToRefreshToken {
						self.refreshTokenThenRetry(target, decoder: decoder, completion: completion)
						return
					}

					guard let mappedApiError = try? errorResponse.map(ApiError.self, using: decoder) else {
						apiError = ApiError.init(message: "Unable to map errorResponse to ApiError")
						break
					}

					apiError = mappedApiError

				}

			case .failure(let error):
				apiError = ApiError.init(message: error.localizedDescription)
			}

			completion(apiError)

		}

	}

}
