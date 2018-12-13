//
//  PusherKeys.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/10/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct PusherKeys: Decodable {
	let id: String
	let key: String
	let secret: String
	let cluster: String
}

extension PusherKeys {

	static let `default`: PusherKeys = PusherKeys.create(fromJSONFileWithName: "pusher_keys")

	static func create(fromJSONFileWithName name: String) -> PusherKeys {
		guard let file = Bundle.main.path(forResource: name, ofType: "json") else {
			fatalError("Unable to find \(name).json in bundle. Not available in repo for security reasons.")
		}
		let jsonString = try! String(contentsOfFile: file)
		let jsonData = jsonString.data(using: .utf8)
		return try! JSONDecoder().decode(PusherKeys.self, from: jsonData!)
	}

}
