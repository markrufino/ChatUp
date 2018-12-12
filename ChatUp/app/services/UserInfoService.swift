//
//  UserInfoService.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/10/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

protocol UserInfoServicing {

	var userName: String { get set }

	var userId: Int { get set }

	var email: String { get set }

	var isOnline: Bool { get set }

}

protocol UserInfoServiceable {
}

class UserInfoService: UserInfoServicing {

	var userName: String
	var userId: Int
	var email: String
	var isOnline: Bool

	init(userName: String, userId: Int, email: String, isOnline: Bool) {
		self.userName = userName
		self.userId = userId
		self.email = email
		self.isOnline = isOnline
	}

}

extension UserInfoService {

	static let `default` = UserInfoService(userName: "Mark Rufino", userId: 2, email: "mark.rufino.io@gmail.com", isOnline: true)

}
