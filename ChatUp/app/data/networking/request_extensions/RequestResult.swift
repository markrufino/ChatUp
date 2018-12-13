//
//  RequestResult.swift
//  
//
//  Created by Mark on 13/12/2018.
//

import Foundation

typealias RequestJSONCompletion<D: Decodable> = (RequestResult<D>) -> Void

enum RequestResult<D: Decodable> {
    case success(D)
    case error(ApiError)
}
