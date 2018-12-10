//
//  UITableView+registerCustomCell.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/10/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

	func registerCustomCell<C: CustomCell>(_ customCell: C.Type) {
		let nib = UINib(nibName: C.identifier, bundle: nil)
		self.register(nib, forCellReuseIdentifier: C.identifier)
	}

}
