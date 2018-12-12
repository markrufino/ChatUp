//
//  UserInfoService.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/10/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

protocol UserInfoServicing {

	var username: String { get }

	var userId: Int { get }

	var email: String { get }

	var isOnline: Bool { get }

	func set(username: String, userId: Int, email: String, isOnline: Bool)

}

protocol UserInfoServiceable {
}  

/// Service for storing session based user info.
class UserInfoService: UserInfoServicing {

	private static let internalDefaults = UserDefaults(suiteName: Config.shared.kNamespace).expect(message: "Unable to init defaults for UserInfoService")

	enum Keys {
		static let username = "UserInfoService.Keys.username"
		static let userId = "UserInfoService.Keys.userId"
		static let email = "UserInfoService.Keys.email"
		static let isOnline = "UserInfoService.Keys.isOnline"
	}

	var username: String {
		return UserInfoService.internalDefaults.string(forKey: Keys.username).expect(message: "Unable to get `username` in UserInfoService defaults.")
	}

	var userId: Int {
		return UserInfoService.internalDefaults.integer(forKey: Keys.userId)
	}

	var email: String {
		return UserInfoService.internalDefaults.string(forKey: Keys.username).expect(message: "Unable to get `email` in UserInfoService defaults.")
	}

	var isOnline: Bool {
		return UserInfoService.internalDefaults.bool(forKey: Keys.isOnline)
	}

	init() {
	}

	func set(username: String, userId: Int, email: String, isOnline: Bool) {
		let defaults = UserInfoService.internalDefaults
		defaults.set(username, forKey: Keys.username)
		defaults.set(userId, forKey: Keys.userId)
		defaults.set(email, forKey: Keys.email)
		defaults.set(isOnline, forKey: Keys.isOnline)
	}

}
