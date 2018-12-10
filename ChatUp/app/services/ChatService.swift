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

	static var authMethod: AuthMethod { get }

	func start()

    func send(chatMessage: ChatMessageKind)

	func stop()
    
}

protocol ChatServiceable {
    
    func chatServiceSuccessfullyConnected()

	func chatServiceReconnecting()
    
    func chatServiceWasDisconnected()

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

	static var authMethod: AuthMethod = .noMethod

	init(_ provider: Provider,
		 withUserInfoService userInfoService: UserInfoServicing,
		 andCredentials credentials: PusherKeys,
		 toService serviceable: ChatServiceable,
		 inChannel channelId: String = "private-general") {

		self.provider = provider
		self.userInfoService = userInfoService
		self.credentials = credentials
		self.serviceable = serviceable
		self.channelId = channelId

		// see: https://pusher.com/docs/authenticating_users
		self.pusher = Pusher(withAppKey: credentials.key, options: {
			PusherClientOptions(authMethod: ChatService.authMethod, attemptToReturnJSONObject: true, host: .cluster(credentials.cluster))
		}())
	}

	// MARK: - Public

	func start() {
		pusher.delegate = self
		pusher.connect()

		channel = pusher.subscribe(channelId)
		channel?.bind(eventName: ChatEvents.messageSent.stringValue, callback: messageSentEventHandler(_:))
	}

	func send(chatMessage: ChatMessageKind) {
		switch chatMessage {
		case .string(let stringMessage):
			process(stringMessage, chatMessage)
		}
	}

	fileprivate func process(_ stringMessage: String, _ chatMessage: ChatMessageKind) {
		let sender = ChatMessageSender(fromUserInfoService: self.userInfoService)
		let message = ChatMessage(message: stringMessage, sender: sender)
		let channelId = 1

		provider.requestPlain(target: .sendMessage(message, channelId)) { (error) in
			guard error == nil else {
				self.serviceable.chatService(failedToSendMessage: chatMessage)
				return
			}
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
	private var channelId: String
	private var pusher: Pusher
	private var channel: PusherChannel?

	private var retriesLeftForConnecting: Int = 1

	// MARK: - Private Methods

	private func messageSentEventHandler(_ data: Any?) {
		// default kind is string message
		guard let body = data as? [String: Any] else { return }
		guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) else { return }
		guard let chatMessage = try? JSONDecoder().decode(ChatMessage.self, from: jsonData) else { return }
		serviceable.chatService(didReceiveMessage: ChatMessageKind.string(chatMessage.message), fromSenderName: chatMessage.sender.name)
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
