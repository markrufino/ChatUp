//
//  ChatViewController.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import UIKit


class ChatViewController: UIViewController, CreatedFromNib {
    
    private var messageTextViewMaxHeight: CGFloat = 132.0
    private var messageTextViewHeightConstraint: NSLayoutConstraint?

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
	}

	private func initUserNameLabel() {
		self.userNameLabel.text = userInfoService?.userName ?? "unknown"
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

	func chatService(failedToSendMessage message: ChatMessageKind) {

	}

	func chatService(didReceiveMessage message: ChatMessageKind, fromSenderName sender: String) {
		switch message {
		case .string(let message):
			print("\(message)")
		}
	}

}

