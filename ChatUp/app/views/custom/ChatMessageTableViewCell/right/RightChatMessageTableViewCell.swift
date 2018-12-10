//
//  RightChatMessageTableViewCell.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/10/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import UIKit

class RightChatMessageTableViewCell: UITableViewCell, CustomCell {

	static let identifier = "RightChatMessageTableViewCell"

	@IBOutlet weak var messageLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
