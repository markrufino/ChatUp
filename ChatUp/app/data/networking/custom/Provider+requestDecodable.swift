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

	func requestPlain(target: API, handler: @escaping ((ApiError?) -> Void)) {
		self.request(target) { (result) in
			switch result {
			case .success:
				handler(nil)
			case .failure(let error):

				guard case .statusCode(let errorResponse) = error else {
					handler(ApiError(message: "Non-Status Code Error"))
					break
				}

				if errorResponse.statusCode == 401 && target.needsToRefreshToken {
					self.requestTokenAndRetry(target: target, plainHandler: handler)
					return
				}

				if let providerError = try? errorResponse.map(ApiError.self) {
					handler(providerError)
				}
			}
		}
	}

    func requestDecodable<D: Decodable>(target: API, decoder: JSONDecoder = Provider.defaultDecoder, handler: @escaping RequestDecodableCompletion<D>) {
        
        self.request(target) { (result) in
            
            var resultType: ResultType<D>!
            
            switch result {
                
            case .success(let value):
                let decodableJSON = try! value.map(D.self, using: decoder, failsOnEmptyData: true)
                resultType = ResultType<D>.success(decodableJSON)
                
            case .failure(let error):
                
                guard case .statusCode(let errorResponse) = error else {
                    resultType = ResultType<D>.failed(ApiError(message: "Non-Status Code Error"))
                    break
                }
                
                if errorResponse.statusCode == 401 && target.needsToRefreshToken {
                    self.refreshTokenAndRetry(target: target, decodableHandler: handler)
                    return
                }
                
                if let providerError = try? errorResponse.map(ApiError.self) {
                    resultType = ResultType<D>.failed(providerError)
                }
                
            }
            
            handler(resultType)
        }
        
    }
    
}
