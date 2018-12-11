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
    case sendMessage(StringChatMessage, Int)
}

extension API: TargetType {
    
    var baseURL: URL {
        return Config.shared.kBaseURL
    }
    
    var path: String {
        switch self {
        case .refreshToken:
            return "/refresh"
		case .sendMessage(_, let channelId):
			return "/channel/\(channelId)/messages"
		}
    }
    
    var method: Moya.Method {
        switch self {
        case .refreshToken:
            return .post
		case .sendMessage:
			return .post
		}
    }
    
    var sampleData: Data {
        switch self {
        case .refreshToken, .sendMessage:
            return "{\"refreshToken\": \"123456\"}".data(using: .utf8)!
		}
    }
    
    var task: Task {
        switch self {
        case .refreshToken:
            return .requestPlain
		case .sendMessage(let params, _):
			return .requestCustomJSONEncodable(params, encoder: JSONEncoder.snakeCaseEncoder)
		}
    }
    
    var headers: [String : String]? {
        return [
			"Content-Type": "application/json"]
//			self.auth.key: self.auth.value
//		]
    }
    
}

// MARK: - API AUTHENTICATION LEVELS

extension API {

    var auth: APIAuthType {
        switch self {
        case .refreshToken, .sendMessage:
            return .none
        }
    }
    
    var needsToRefreshToken: Bool {
        switch self {
        case .refreshToken, .sendMessage:
            return false
        }
    }
    
}
