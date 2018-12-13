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

    func send(chatMessage: ChatMessageType)

	func stop()
    
}

protocol ChatServiceable: AnyObject {
    
    func chatServiceSuccessfullyConnected()

	func chatServiceReconnecting()
    
    func chatServiceWasDisconnected()

	func chatService(failedToGetChannelInfoFor forChannelId: Int, withErrorMessage errorMessage: String)

	func chatService(successfullySentMessage message: ChatMessageType)

	func chatService(failedToSendMessage message: ChatMessageType)

	func chatService(didReceiveMessage message: ChatMessageType, fromSenderName sender: String)
    
}

enum ChatEvents {
    
    case newMessage
    case typing
    
    var stringValue: String {
        switch self {
        case .newMessage:
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
		 servicing serviceable: ChatServiceable,
		 inChannel channelId: Int) {

		self.provider = provider
		self.userInfoService = userInfoService
		self.credentials = credentials
		self.serviceable = serviceable
		self.channelId = channelId

		// see: https://pusher.com/docs/authenticating_users
		self.pusher = Pusher(withAppKey: credentials.key, options: {
			let authMethod: AuthMethod = .inline(secret: credentials.secret)
			return PusherClientOptions(authMethod: authMethod, attemptToReturnJSONObject: true, host: .cluster(credentials.cluster))
		}())
	}

	// MARK: - Public

	func start() {

		self.provider.requestJSON(.getChannelInfo(channelId: self.channelId)) { [unowned self] (result: RequestResult<ChannelResponse>) in
			switch result {
			case .success(let value):
				let channel = value.data

				self.pusher.delegate = self
				self.pusher.connect()

				self.channel = self.pusher.subscribe(channelName: channel.name)
				self.channel?.bind(eventName: ChatEvents.newMessage.stringValue, callback: self.messageSentEventHandler(_:))

			case .error(let error):
				self.serviceable?.chatService(failedToGetChannelInfoFor: self.channelId, withErrorMessage: error.localizedDescription)
			}
		}

	}

	func send(chatMessage: ChatMessageType) {
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
	private weak var serviceable: ChatServiceable?
	private var channelId: Int

	private var pusher: Pusher
	private var channel: PusherChannel?

	private var retriesLeftForConnecting: Int = 1

	// MARK: - Private Methods

	private func messageSentEventHandler(_ data: Any?) {
		// default kind is string message
		guard let body = data as? [String: Any] else { return }
		guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) else { return }
		guard let chatMessage = try? JSONDecoder().decode(ChatMessageResponse.self, from: jsonData) else { return }

		let stringChatMessage = chatMessage.data.message ?? ""
		let senderName = chatMessage.data.sender.data.name

		serviceable?.chatService(didReceiveMessage: ChatMessageType.string(stringChatMessage), fromSenderName: senderName)
	}

	private func send(_ stringMessage: String, _ chatMessage: ChatMessageType) {

		let sender: ChatMessageSender = ChatMessageSender(fromUserInfoService: self.userInfoService)
		let message = ChatMessageParams(message: stringMessage, sender: sender)

		provider.requestPlain(.sendMessage(params: message, channelId: channelId)) { (error) in
			guard error == nil else {
				self.serviceable?.chatService(failedToSendMessage: chatMessage)
				return
			}
			self.serviceable?.chatService(successfullySentMessage: chatMessage)
		}

	}
    
}

extension ChatService: PusherDelegate {
    
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
		print("Pusher Changed Connection State - old: \(old.stringValue()) -> new: \(new.stringValue())")
		switch (old, new) {
		case (_, .reconnecting):
			serviceable?.chatServiceReconnecting()
		case (_, .connected):
			serviceable?.chatServiceSuccessfullyConnected()
		case (_, .disconnected):
			serviceable?.chatServiceWasDisconnected()
		default:
			break
		}
    }
    
}
