//
//  LoginBuilder.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct LoginDependency: DependencyType {
	var coordinator: LoginCoordinator
}

class LoginBuilder: BuilderType<LoginViewController, LoginDependency> {

	override func build(_ dependency: LoginDependency) -> LoginViewController {
		let provider = Provider.default
		let userInfoService = UserInfoService()
		view.coordinator = dependency.coordinator
		view.loginService = LoginService(withProvider: provider, andUserInfoService: userInfoService, servicing: view)
		return view
	}

}
