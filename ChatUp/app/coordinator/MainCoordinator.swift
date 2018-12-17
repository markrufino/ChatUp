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
		self.rootViewController = RootBuilder().build(dependency)
		window.rootViewController = self.rootViewController
		window.makeKeyAndVisible()
	}

	// MARK: -
	private var navigationVc: UINavigationController?
	private var rootViewController: RootViewController?

	private func setupNavigationVc() -> UINavigationController {
		let dependency = LoginDependency(coordinator: self)
		let builder = LoginBuilder()
		let navVc = UINavigationController(rootViewController: builder.build(dependency))
		navVc.setNavigationBarHidden(true, animated: false)
		return navVc
	}

}

extension MainCoordinator: RootCoordinator {

	func rootGoToLogin() {
		navigationVc = setupNavigationVc()
		rootViewController?.present(navigationVc.expect(message: "navigationVc should be available at this point."), animated: true, completion: nil)
	}

}

extension MainCoordinator: LoginCoordinator {

	func loginGoToChat() {
		let dependency = ChatDependency(coordinator: self)
		let builder = ChatBuilder()
		navigationVc?.pushViewController(builder.build(dependency), animated: true)
	}

	func loginGoToRegistration() {
		let dependency = RegistrationDependency(coordinator: self)
		let builder = RegistrationBuilder()
		navigationVc?.pushViewController(builder.build(dependency), animated: true)
	}

}

extension MainCoordinator: RegistrationCoordinator {

	func registrationGoBackToLogin() {
		navigationVc?.popToRootViewController(animated: true)
	}

	func registrationGoToChat() {
		let dependency = ChatDependency(coordinator: self)
		let builder = ChatBuilder()
		navigationVc?.pushViewController(builder.build(dependency), animated: true)
	}

}

extension MainCoordinator: ChatCoordinator {

	func chatLogoutToLoginScreen() {
		navigationVc?.popToRootViewController(animated: true)
	}

}
