//
//  ChannelResponse.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/13/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

typealias ChannelResponse = DataResp<Channel>

struct Channel: Codable {

	let id: Int
	let name: String
	let isPrivate: Bool
	let messages: DataResp<[ChatMessageResponse]>
	let members: DataResp<[User]>

}
