//
//  LoginService.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

protocol LoginServicing {

	func login(withEmail email: String, andPassword password: String)

}

protocol LoginServiceable: AnyObject {

	func loginSuccess()
	
	func loginFailed(withError message: String)

}

class LoginService: LoginServicing {

	init(withProvider provider: Provider, andUserInfoService userInfoService: UserInfoService, servicing serviceable: LoginServiceable) {
		self.provider = provider
		self.userInfoService = userInfoService
		self.serviceable = serviceable
	}

	func login(withEmail email: String, andPassword password: String) {

		provider.requestJSON(.login(email: email, password: password)) { (result: RequestResult<LoginResponse>) in
			switch result {
			case .success(let value):
				let user = value.data
				self.userInfoService.set(username: user.name, userId: user.id, email: user.email, isOnline: user.isOnline)
				self.serviceable?.loginSuccess()
			case .error(let error):
				self.serviceable?.loginFailed(withError: error.localizedDescription)
			}
		}

	}

	// MARK: - Private

	private var provider: Provider
	private var userInfoService: UserInfoServicing
	private weak var serviceable: LoginServiceable?

}

