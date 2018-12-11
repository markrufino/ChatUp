//
//  LeftChatMessageTableViewCell.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/10/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import UIKit

class LeftChatMessageTableViewCell: UITableViewCell, CustomCell {

	static let identifier = "LeftChatMessageTableViewCell"

	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var senderNameLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
