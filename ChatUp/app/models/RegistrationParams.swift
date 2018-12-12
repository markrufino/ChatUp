//
//  RegistrationParams.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct RegistrationParams: Encodable {
	let name: String
	let email: String
	let password: String
}
