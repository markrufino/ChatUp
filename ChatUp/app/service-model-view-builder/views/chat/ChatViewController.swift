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
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var pushService: ChatServicing?

    override func viewDidLoad() {
        super.viewDidLoad()
        pushService?.start(usingCredentials: PusherCredentials.default, withServiceable: self)
        initMessageTextView()
    }
    
    private func initMessageTextView() {
        messageTextViewHeightConstraint = messageTextView.heightAnchor.constraint(equalToConstant: 44)
        messageTextViewHeightConstraint?.isActive = true
        messageTextView.isScrollEnabled = false
        messageTextView.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSend(_ sender: UIButton) {
        sendStringMessage()
    }
    
    private func sendStringMessage() {
        guard let message = messageTextView.text else { return }
        messageTextView.text = ""
        textViewDidChange(messageTextView)
        pushService?.send(message: .string(message))
    }
    
}

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let clampedHeight = min(messageTextViewMaxHeight, max(44.0, newSize.height))
        messageTextViewHeightConstraint?.constant = clampedHeight
        textView.isScrollEnabled = newSize.height >= messageTextViewMaxHeight
        if textView.isScrollEnabled {
            print("f")
        }
    }
    
}

extension ChatViewController: ChatServiceable {
    
    func allowedChatServiceConnectionRetries() -> Int {
        return 10
    }
    
    func chatServiceSuccessfullyConnected() {
        print("Nice, you are now connected to the channel after <allowedRetries - retriesLeft> retries!")
    }
    
    func chatServiceConnectionFailed(withRetriesLeft retriesLeft: Int) {
        let allowedRetries = allowedChatServiceConnectionRetries()
        if retriesLeft == 0 {
            print("Failed to connect after \(allowedRetries) retries.")
            return
        }
        print("Attempting to reconnect. Retries left: \(retriesLeft)/\(allowedRetries)")
    }
    
    func chatService(receivedMessage: ChatMessageType, from sender: String) {
        if case .string(let message) = receivedMessage {
            print("Received string message \(message)")
        }
    }
    
}

