//
//  AuthTokenExtractorPlugin.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/13/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import Result
import Moya

class AuthTokenExtractorPlugin: PluginType {

	// TODO: - Port refresh token here as well.
	func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
		let api = target as! API
		switch api {
		case .login, .refreshToken:
			switch result {
			case .success(let response):

				if let successfulResp = try? response.filterSuccessfulStatusCodes() {
					if let header = successfulResp.response?.allHeaderFields {
						if let newAccessToken = header[HeaderKeys.AUTHORIZATION] {
							Keychain().apiAccessToken = newAccessToken as? String
						}
					}
				}

			case .failure(let error):
				print(error.localizedDescription)
			}
		default:
			break
		}

	}

}
