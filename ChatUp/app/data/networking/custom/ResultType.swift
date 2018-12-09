//
//  ResultType.swift
//  StarterKit
//
//  Created by Mark on 02/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

enum ResultType<D: Decodable> {
    case success(D)
    case failed(ApiError)
}
