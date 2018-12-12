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

	init(withProvider provider: Provider, servicing serviceable: LoginServiceable) {
		self.provider = provider
		self.serviceable = serviceable
	}

	func login(withEmail email: String, andPassword password: String) {
		provider.requestDecodable(target: .login(email: email, password: password)) { (result: ResultType<User>) in
			switch result {
			case .success(let user):
				self.serviceable?.loginSuccess()
			case .failed(let error):
				self.serviceable?.loginFailed(withError: error.localizedDescription)
			}
		}
	}

	// MARK: - Private

	private var provider: Provider
	private weak var serviceable: LoginServiceable?

}

