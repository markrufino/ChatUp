//
//  LoginBuilder.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

class LoginBuilder: BuilderType<LoginViewController> {

	override func build() -> LoginViewController {
		let provider = Provider.default
		let userInfoService = UserInfoService()
		view.loginService = LoginService(withProvider: provider, andUserInfoService: userInfoService, servicing: view)
		return view
	}

}
