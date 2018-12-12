//
//  DataResp.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/10/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct DataResp<C: Codable>: Codable {
	let data: C
}
