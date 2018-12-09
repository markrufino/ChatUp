//
//  ApiError.swift
//  StarterKit
//
//  Created by Mark on 02/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct ApiError: Decodable {
    var message: String
}

extension ApiError: Swift.Error, LocalizedError {
    var errorDescription: String? {
        return message
    }
}

