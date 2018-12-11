//
//  ChatViewController.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import UIKit


class ChatViewController: UIViewController, CreatedFromNib {

	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var onlineStatusIndicatorView: UIView!
	@IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!

	var userInfoService: UserInfoServicing?
    var chatService: ChatServicing?

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		chatService?.start()
	}

	private func initViews() {
		initUserNameLabel()
		initMessageTextView()
		initOnlineStatusIndicator()
		initChatTableView()
	}

	private func initUserNameLabel() {
		userNameLabel.text = userInfoService?.userName ?? "unknown"
	}

	private func initChatTableView() {
		chatTableView.registerCustomCell(LeftChatMessageTableViewCell.self)
		chatTableView.registerCustomCell(RightChatMessageTableViewCell.self)
		chatTableView.delegate = self
		chatTableView.dataSource = self

		chatTableView.separatorStyle = .none
		chatTableView.rowHeight = UITableView.automaticDimension
		chatTableView.estimatedRowHeight = 999

		DispatchQueue.main.async {
			self.chatTableView.contentOffset.y = 32
		}

	}
    
    private func initMessageTextView() {
        messageTextViewHeightConstraint = messageTextView.heightAnchor.constraint(equalToConstant: 41.0)
        messageTextViewHeightConstraint?.isActive = true
        messageTextView.isScrollEnabled = false
        messageTextView.delegate = self
    }

	private func initOnlineStatusIndicator() {
		onlineStatusIndicatorView.cornerRadius = 8.0
		onlineStatusIndicatorView.backgroundColor = UIColor.lightGray
	}
    
    // MARK: - Actions
    
    @IBAction func didTapSend(_ sender: UIButton) {
        sendStringMessage()
    }
    
    private func sendStringMessage() {
        guard let message = messageTextView.text else { return }
		clearMessageTextView()
		chatService?.send(chatMessage: .string(message))
    }

	private func clearMessageTextView() {
		messageTextView.text = ""
		textViewDidChange(messageTextView)
	}

	// MARK: - Private

	private var messageTextViewMaxHeight: CGFloat = 132.0
	private var messageTextViewHeightConstraint: NSLayoutConstraint?
	private var chatMessages: [ChatMessageViewModel] = []

	private func updateTableViewWithChatMessage(_ chatMessage: ChatMessageViewModel) {
		chatMessages.append(chatMessage)
		chatTableView.reloadData()
	}

}

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let clampedHeight = min(messageTextViewMaxHeight, max(41.0, newSize.height))
        messageTextViewHeightConstraint?.constant = clampedHeight
        textView.isScrollEnabled = newSize.height >= messageTextViewMaxHeight
    }
    
}

extension ChatViewController: UITableViewDelegate {

}

extension ChatViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return chatMessages.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let chatMessage = chatMessages[indexPath.row]
		switch chatMessage.side {
		case .left(let senderName):
			let leftSideChat = tableView.dequeueReusableCell(withIdentifier: LeftChatMessageTableViewCell.identifier, for: indexPath) as! LeftChatMessageTableViewCell
			leftSideChat.senderNameLabel.text = senderName
			if let stringMessage = chatMessage.text {
				leftSideChat.messageLabel?.text = stringMessage
			}
			leftSideChat.selectionStyle = .none
			return leftSideChat
		case .right:
			let rightSideChat = tableView.dequeueReusableCell(withIdentifier: RightChatMessageTableViewCell.identifier, for: indexPath) as! RightChatMessageTableViewCell
			if let stringMessage = chatMessage.text {
				rightSideChat.messageLabel?.text = stringMessage
			}
			rightSideChat.selectionStyle = .none
			return rightSideChat
		}
	}

}

extension ChatViewController: ChatServiceable {

	func chatServiceSuccessfullyConnected() {
		onlineStatusIndicatorView.backgroundColor = UIColor.green
	}

	func chatServiceReconnecting() {
		onlineStatusIndicatorView.backgroundColor = UIColor.lightGray
	}

	func chatServiceWasDisconnected() {
		onlineStatusIndicatorView.backgroundColor = UIColor.red
	}

	func chatService(successfullySentMessage message: ChatMessageKind) {
		let chatMessageViewModel: ChatMessageViewModel
		switch message {
		case .string(let stringMessage):
			chatMessageViewModel = ChatMessageViewModel(withText: stringMessage, andOrMedia: nil, thatWillAppearOnThe: .right)
		}
		updateTableViewWithChatMessage(chatMessageViewModel)
	}

	func chatService(failedToSendMessage message: ChatMessageKind) {
		// Failed to send message
	}

	func chatService(didReceiveMessage message: ChatMessageKind, fromSenderName sender: String) {
		let chatMessageViewModel: ChatMessageViewModel
		switch message {
		case .string(let stringMessage):
			chatMessageViewModel = ChatMessageViewModel(withText: stringMessage, andOrMedia: nil, thatWillAppearOnThe: .left(senderName: sender))
		}
		updateTableViewWithChatMessage(chatMessageViewModel)
	}

}

