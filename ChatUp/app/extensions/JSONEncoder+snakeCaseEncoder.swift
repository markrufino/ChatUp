//
//  JSONEncoder+snakeCaseEncoder.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/10/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

extension JSONEncoder {

	static let snakeCaseEncoder: JSONEncoder = {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		return encoder
	}()

}
