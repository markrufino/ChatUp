//
//  Provider+requestDecodable.swift
//  StarterKit
//
//  Created by Mark on 02/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Result
import Moya

typealias RequestDecodableCompletion<D: Decodable> = (ResultType<D>) -> Void

extension Provider {
    
    private static let defaultDecoder: JSONDecoder = {
        let defaultDecoder = JSONDecoder()
        defaultDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return defaultDecoder
    }()

	func request(target: API, handler: @escaping ((ApiError?) -> Void)) {
		self.request(target) { (result) in
			switch result {
			case .success(let response):

				if response.statusCode >= 400 {

				} else {
					handler(nil)
				}


			case .failure(let error):

				guard case .statusCode(let errorResponse) = error else {
					handler(ApiError(message: "Non-Status Code Error"))
					break
				}

				if errorResponse.statusCode == 401 && target.needsToRefreshToken {
					self.requestTokenAndRetry(target: target, handler: handler)
					return
				}

				if let providerError = try? errorResponse.map(ApiError.self, using: JSONDecoder.snakeCaseDecoder) {
					handler(providerError)
				}
			}
		}
	}

    func requestDecodable<D: Decodable>(target: API, decoder: JSONDecoder = Provider.defaultDecoder, handler: @escaping RequestDecodableCompletion<D>) {

        self.request(target) { (result) in
            
            var resultType: ResultType<D>!

            switch result {
                
            case .success(let response):


				do {

					let decodable = try response.filterSuccessfulStatusCodes()
					let decodableJSON = try! decodable.map(D.self, using: decoder, failsOnEmptyData: true)
					resultType = ResultType<D>.success(decodableJSON)

				} catch {

					if let err = error as? MoyaError {
						print(err.response?.statusCode)
						print("")
					}

				}

            case .failure(let error):

                guard case .statusCode(let errorResponse) = error else {
                    resultType = ResultType<D>.failed(ApiError(message: "Non-Status Code Error"))
                    break
                }
                
                if errorResponse.statusCode == 401 && target.needsToRefreshToken {
                    self.refreshTokenAndRetry(target: target, handler: handler)
                    return
                }
                
                if let providerError = try? errorResponse.map(ApiError.self, using: JSONDecoder.snakeCaseDecoder) {
                    resultType = ResultType<D>.failed(providerError)
                }
                
            }
            
            handler(resultType)
        }
        
    }
    
}
