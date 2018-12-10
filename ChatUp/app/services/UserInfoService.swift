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

}

protocol UserInfoServiceable {
}

class UserInfoService: UserInfoServicing {

	var userName: String
	var userId: Int

	init(userName: String, userId: Int) {
		self.userName = userName
		self.userId = userId
	}

}

extension UserInfoService {

	static let `default` = UserInfoService(userName: "Mark Rufino", userId: 2)

}
