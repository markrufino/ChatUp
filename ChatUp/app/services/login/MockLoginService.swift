//
//  MockLoginService.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/14/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

class MockLoginService: LoginServicing {

	private weak var serviceable: LoginServiceable?
	var userInfoService: UserInfoServicing

	init(serviceable: LoginServiceable, andUserInfoService userInfoService: UserInfoServicing) {
		self.serviceable = serviceable
		self.userInfoService = userInfoService
	}

	func login(withEmail email: String, andPassword password: String) {
		userInfoService.set(username: "Mark Rufino", userId: 0, email: "mark.rufino.io@gmail.com", isOnline: true)
		serviceable?.loginSuccess()
	}

}
