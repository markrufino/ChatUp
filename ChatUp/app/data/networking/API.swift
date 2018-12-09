//
//  API.swift
//  StarterKit
//
//  Created by Mark on 24/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import Moya

enum API {
    case refreshToken
    case sample
}

extension API: TargetType {
    
    var baseURL: URL {
        return Config.shared.kBaseURL
    }
    
    var path: String {
        switch self {
        case .sample:
            return "/sample"
        case .refreshToken:
            return "/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sample:
            return .get
        case .refreshToken:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        case .sample:
            return "{\"message\": \"Hello World!\"}".data(using: .utf8)!
        case .refreshToken:
            return "{\"refreshToken\": \"123456\"}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .sample:
            return .requestPlain
        case .refreshToken:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [self.auth.key: self.auth.value]
    }
    
}

// MARK: - API AUTHENTICATION LEVELS

extension API {

    var auth: APIAuthType {
        switch self {
        case .sample:
            return .none
        case .refreshToken:
            return .none
        }
    }
    
    var needsToRefreshToken: Bool {
        switch self {
        case .sample, .refreshToken:
            return false
        }
    }
    
}
