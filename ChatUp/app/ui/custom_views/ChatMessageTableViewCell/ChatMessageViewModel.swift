//
//  ChatMessageViewModel.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct ChatMessageViewModel {

	enum Side {
		case left(senderName: String)
		case right
	}

	enum Media {
		case image(Data)
		case audio(Data)
	}

	var text: String?
	var media: Media?
	var side: Side

	init(withText text: String?, andOrMedia media: Media?, thatWillAppearOnThe side: Side) {
		self.text = text
		self.media = media
		self.side = side
	}

}
