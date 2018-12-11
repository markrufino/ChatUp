//
//  MockChatService.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

class MockChatService: ChatServicing {

	var responses = [
		"Hello world!",
		"I AM MOCK CHAT SERVICE",
		"This\nIs\nA\nLong\nLine"
	]

	private let serviceable: ChatServiceable

	init(serviceable: ChatServiceable) {
		self.serviceable = serviceable
	}

	func start() {
	}

	func send(chatMessage: ChatMessageKind) {
		serviceable.chatService(successfullySentMessage: chatMessage)
		let randomResponse = responses[Int.random(in: 0 ... 2)]
		serviceable.chatService(didReceiveMessage: ChatMessageKind.string(randomResponse), fromSenderName: "MockChatService")
	}

	func stop() {
	}

}
