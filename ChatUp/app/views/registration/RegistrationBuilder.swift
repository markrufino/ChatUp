//
//  RegistrationBuilder.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/14/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

class RegistrationBuilder: BuilderType<RegistrationViewController> {

	override func build() -> RegistrationViewController {
		let provider = Provider.default
		let userInfoService = UserInfoService()
		let registrationService = RegistrationService(withProvider: provider, andUserInfoService: userInfoService, toService: view)
		view.registrationService  = registrationService
		return view
	}

}
