//
//  ApiError.swift
//  StarterKit
//
//  Created by Mark on 02/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

enum CustomErrorMessageType: Decodable {

	case string(String)
	case dict([String: [String]])

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		do {
			self = try .string(container.decode(String.self))
		} catch DecodingError.typeMismatch {
			self = try .dict(container.decode([String: [String]].self))
		}
	}

}

struct CustomError: Decodable {
	let code: String
	let httpCode: Int
	var message: CustomErrorMessageType
}

struct ApiError: Decodable {
    var message: String?
	var error: CustomError?

	init(message: String) {
		self.message = message
	}

	func getErrorMessage() -> String {
		if let customError = self.error {
			switch customError.message {
			case .string(let message):
				return message
			case .dict(let dictMessages):
				return "keyed messages"
			}
		}
		guard message != nil else {
			return "<no error message>"
		}
		return self.message!
	}

}

extension ApiError: Swift.Error, LocalizedError {
    var errorDescription: String? {
		return self.getErrorMessage()
    }
}

