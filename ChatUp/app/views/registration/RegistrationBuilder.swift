//
//  RegistrationBuilder.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/14/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct RegistrationDependency: DependencyType {
	var coordinator: RegistrationCoordinator
}

class RegistrationBuilder: BuilderType<RegistrationViewController, RegistrationDependency> {

	override func build(_ dependency: RegistrationDependency) -> RegistrationViewController {
		let provider = Provider.default
		let userInfoService = UserInfoService()

		#if DEBUG
			let registrationService = MockRegistrationService(serviceable: view)
		#else
			let registrationService = RegistrationService(withProvider: provider, andUserInfoService: userInfoService, toService: view)
		#endif

		view.coordinator = dependency.coordinator
		view.registrationService  = registrationService
		return view
	}

}
