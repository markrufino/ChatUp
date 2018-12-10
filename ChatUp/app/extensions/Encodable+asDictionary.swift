//
//  Encodable+asDictionary.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/10/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

extension Encodable {

	func convertToDictionary(usingEncoder encoder: JSONEncoder = JSONEncoder.snakeCaseEncoder) throws -> [String: Any] {
		let data = try encoder.encode(self)
		guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
			fatalError("Unable to serialize data to dictionary.")
		}
		return dictionary
	}

}
