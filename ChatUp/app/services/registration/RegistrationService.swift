//
//  RegistrationService.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/14/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

protocol RegistrationServicing {

	func registerUser(withName name: String, email: String, andPassword password: String)

}

protocol RegistrationServiceable: AnyObject {

	func registrationSuccess()

	func registrationFailed(withError message: String)

}

class RegistrationService: RegistrationServicing {

	init(withProvider provider: Provider, andUserInfoService userInfoService: UserInfoService, toService serviceable: RegistrationServiceable) {
		self.provider = provider
		self.serviceable = serviceable
		self.userInfoService = userInfoService
	}

	func registerUser(withName name: String, email: String, andPassword password: String) {
		let params = RegistrationParams(name: name, email: email, password: password)
		provider.requestJSON(.register(params: params)) { (result: RequestResult<RegistrationResponse>) in
			switch result {
			case .success(let value):
				let user = value.data
				self.userInfoService.set(username: user.name, userId: user.id, email: user.email, isOnline: user.isOnline)
				self.serviceable?.registrationSuccess()
			case .error(let error):
				self.serviceable?.registrationFailed(withError: error.localizedDescription)
			}
		}
	}

	//MARK: - Private
	private weak var serviceable: RegistrationServiceable?
	private var provider: Provider
	private var userInfoService: UserInfoService

}
