//
//  ChatService.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import PusherSwift

protocol ChatServicing {

	func start()

    func send(chatMessage: ChatMessageKind)

	func stop()
    
}

protocol ChatServiceable {
    
    func chatServiceSuccessfullyConnected()

	func chatServiceReconnecting()
    
    func chatServiceWasDisconnected()

	func chatService(successfullySentMessage message: ChatMessageKind)

	func chatService(failedToSendMessage message: ChatMessageKind)

	func chatService(didReceiveMessage message: ChatMessageKind, fromSenderName sender: String)
    
}

enum ChatEvents {
    
    case messageSent
    case typing
    
    var stringValue: String {
        switch self {
        case .messageSent:
            return "message-sent"
        case .typing:
            return "typing"
        }
    }

}

class ChatService: ChatServicing {

	init(_ provider: Provider,
		 withUserInfoService userInfoService: UserInfoServicing,
		 andCredentials credentials: PusherKeys,
		 toService serviceable: ChatServiceable,
		 inChannel channelName: String = "private-general") {

		self.provider = provider
		self.userInfoService = userInfoService
		self.credentials = credentials
		self.serviceable = serviceable
		self.channelName = channelName

		// see: https://pusher.com/docs/authenticating_users
		self.pusher = Pusher(withAppKey: credentials.key, options: {
			let authMethod: AuthMethod = .inline(secret: credentials.secret)
			return PusherClientOptions(authMethod: authMethod, attemptToReturnJSONObject: true, host: .cluster(credentials.cluster))
		}())
	}

	// MARK: - Public

	func start() {
		pusher.delegate = self
		pusher.connect()
		channel = pusher.subscribe(channelName: channelName)
		channel?.bind(eventName: ChatEvents.messageSent.stringValue, callback: messageSentEventHandler(_:))
	}

	func send(chatMessage: ChatMessageKind) {
		switch chatMessage {
		case .string(let stringMessage):
			send(stringMessage, chatMessage)
		}
	}

	func stop() {
		pusher.disconnect()
	}

	// MARK: - Private
	private var provider: Provider
	private var userInfoService: UserInfoServicing
	private var credentials: PusherKeys
	private var serviceable: ChatServiceable
	private var channelName: String
	private var pusher: Pusher
	private var channel: PusherChannel?

	private var retriesLeftForConnecting: Int = 1

	// MARK: - Private Methods

	private func messageSentEventHandler(_ data: Any?) {
		// default kind is string message
		guard let body = data as? [String: Any] else { return }
		guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) else { return }
		guard let chatMessage = try? JSONDecoder().decode(DataParam<StringChatMessage>.self, from: jsonData) else { return }

		let stringChatMessage = chatMessage.data.message
		let senderName = chatMessage.data.sender.data.name

		serviceable.chatService(didReceiveMessage: ChatMessageKind.string(stringChatMessage), fromSenderName: senderName)
	}

	private func send(_ stringMessage: String, _ chatMessage: ChatMessageKind) {

		let sender: ChatMessageSender = ChatMessageSender(fromUserInfoService: self.userInfoService)

		let message = StringChatMessageOutbound(message: stringMessage, sender: sender)
		let channelId = 1 // TODO Direct here via initializer.

		provider.requestPlain(target: .sendMessage(message, channelId)) { (error) in
			guard error == nil else {
				self.serviceable.chatService(failedToSendMessage: chatMessage)
				return
			}
			self.serviceable.chatService(successfullySentMessage: chatMessage)
		}
	}
    
}

extension ChatService: PusherDelegate {
    
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
		print("Pusher Changed Connection State - old: \(old.stringValue()) -> new: \(new.stringValue())")
		switch (old, new) {
		case (_, .reconnecting):
			serviceable.chatServiceReconnecting()
		case (_, .connected):
			serviceable.chatServiceSuccessfullyConnected()
		case (_, .disconnected):
			serviceable.chatServiceWasDisconnected()
		default:
			break
		}
    }
    
}
