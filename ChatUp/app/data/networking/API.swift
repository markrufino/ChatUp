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
	case login(email: String, password: String)
    case sendMessage(StringChatMessageOutbound, Int)
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
		case .login:
			return "/login"
		}
    }
    
    var method: Moya.Method {
        switch self {
        case .refreshToken:
            return .post
		case .sendMessage:
			return .post
		case .login:
			return .post
		}
    }
    
    var sampleData: Data {
        switch self {
        case .refreshToken, .sendMessage, .login:
            return "{\"refreshToken\": \"123456\"}".data(using: .utf8)!
		}
    }
    
    var task: Task {
        switch self {
        case .refreshToken:
            return .requestPlain
		case .sendMessage(let params, _):
			return .requestCustomJSONEncodable(params, encoder: JSONEncoder.snakeCaseEncoder)
		case .login(let email, let password):
			let parameters = ["credentials": ["email": email, "password": password]]
			return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
		}
    }
    
    var headers: [String : String]? {

		let keychain = Keychain()
		let fcmToken = keychain.fcmToken ?? "<not yet set>"

		var baseHeader = ["X-Device-UDID" : UIDevice.udid,
						  "X-Device-OS" : UIDevice.os,
						  "X-Device-OS-Version" : UIDevice.osVersion,
						  "X-Device-Manufacturer" : UIDevice.manufacturer,
						  "X-Device-Model" : UIDevice.model,
						  "X-Device-FCM-Token" : fcmToken,
						  "X-Device-App-Version" : UIDevice.appVersion]

		switch auth {
		case .accessToken:
			guard let accessToken = keychain.apiAccessToken else {
				fatalError("ERROR: Attempting call an authenticated endpoint w/o an access token!")
			}
			baseHeader["Authorization"] = "Bearer \(accessToken)"
			return baseHeader
		case .none:
			return baseHeader
		}


    }
    
}

// MARK: - API AUTHENTICATION LEVELS

extension API {

    var auth: APIAuthType {
        switch self {
        case .refreshToken, .sendMessage, .login:
            return .none
        }
    }
    
    var needsToRefreshToken: Bool {
        switch self {
        case .refreshToken, .sendMessage, .login:
            return false
        }
    }
    
}
