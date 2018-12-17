//
//  MainCoordinator.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/14/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator {

	var window: UIWindow

	init(window: UIWindow) {
		self.window = window
	}

	func start() {
		let dependency = RootDependency(coordinator: self)
		navigationVc = UINavigationController(rootViewController: RootBuilder().build(dependency))
		window.rootViewController = navigationVc
		window.makeKeyAndVisible()
	}

	// MARK: -
	private var navigationVc: UINavigationController?
	private var loginViewController: LoginViewController!

}

extension MainCoordinator: RootCoordinator {

	func rootGoToLogin() {
		let dependency = LoginDependency(coordinator: self)
		loginViewController = LoginBuilder().build(dependency)
		navigationVc?.pushViewController(loginViewController, animated: true)
	}

}

extension MainCoordinator: LoginCoordinator {

	func loginGoToChat() {
		let dependency = ChatDependency(coordinator: self)
		navigationVc?.pushViewController(ChatBuilder().build(dependency), animated: true)
	}

	func loginGoToRegistration() {
		let dependency = RegistrationDependency(coordinator: self)
		navigationVc?.pushViewController(RegistrationBuilder().build(dependency), animated: true)
	}

}

extension MainCoordinator: RegistrationCoordinator {

	func registrationGoBackToLogin() {
		navigationVc?.popToViewController(loginViewController, animated: true)
	}

	func registrationGoToChat() {
		let dependency = ChatDependency(coordinator: self)
		navigationVc?.pushViewController(ChatBuilder().build(dependency), animated: true)
	}

}

extension MainCoordinator: ChatCoordinator {

	func chatLogoutToLoginScreen() {
		navigationVc?.popToViewController(loginViewController, animated: true)
	}

}
