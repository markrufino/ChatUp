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
	case register(params: RegistrationParams)
	case login(email: String, password: String)
	case logout
	case refreshToken
	case getChannelInfo(channelId: Int)
	case sendMessage(params: ChatMessageParams, channelId: Int)
}

extension API: TargetType {
    
    var baseURL: URL {
        return Config.shared.kBaseURL
    }
    
    var path: String {
        switch self {

		case .register: return "/register"

		case .login: return "/login"

		case .logout: return "/logout"

		case .refreshToken: return "/refresh"

		case .getChannelInfo(let channelId): return "/channel/\(channelId)"

		case .sendMessage(_, let channelId): return "/channel/\(channelId)/messages"

		}
    }
    
    var method: Moya.Method {
        switch self {

		case .refreshToken: return .post

		case .login: return .post

		case .logout: return .post

		case .getChannelInfo: return .get

		case .register: return .post

		case .sendMessage: return .post

		}
    }
    
    var sampleData: Data {
		return "{}".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {

		case .register(let params):
			return .requestJSONEncodable(params)

		case .login(let email, let password):
			let parameters = ["credentials": ["email": email, "password": password]]
			return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)

		case .logout:
			return .requestPlain

		case .refreshToken:
			return .requestPlain

		case .getChannelInfo:
			return .requestPlain

		case .sendMessage(let params, _):
			return .requestCustomJSONEncodable(params, encoder: JSONEncoder.snakeCaseEncoder)

		}
    }
    
    var headers: [String : String]? {

		let keychain = Keychain()
		let fcmToken = keychain.fcmToken ?? "<not yet set>"

		var baseHeader = [
			HeaderKeys.X_DEVICE_UDID : UIDevice.udid,
			HeaderKeys.X_DEVICE_OS : UIDevice.os,
			HeaderKeys.X_DEVICE_OS_VERSION: UIDevice.osVersion,
			HeaderKeys.X_DEVICE_MANUFACTURER: UIDevice.manufacturer,
			HeaderKeys.X_DEVICE_MODEL : UIDevice.model,
			HeaderKeys.X_DEVICE_FCM_TOKEN: fcmToken,
			HeaderKeys.X_DEVICE_APP_VERSION : UIDevice.appVersion
		]

		switch auth {

		case .accessToken:
			guard let accessToken = keychain.apiAccessToken else {
				fatalError("ERROR: Attempting call an authenticated endpoint w/o an access token!")
			}
			baseHeader[HeaderKeys.AUTHORIZATION] = "Bearer \(accessToken)"
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
		case .register,
			 .logout,
			 .getChannelInfo:
			return .accessToken
		}
    }
    
    var needsToRefreshToken: Bool {
        switch self {
		case .refreshToken,
			 .register,
			 .login,
			 .logout:
			return false
		case .getChannelInfo,
			 .sendMessage:
			return true
		}
    }
    
}
