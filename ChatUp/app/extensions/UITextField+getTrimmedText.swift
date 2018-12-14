//
//  UITextField+getTrimmedText.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/14/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {

	func getTrimmedText() -> String? {
		guard let t = self.text else { return nil }
		guard t.trimmingCharacters(in: .whitespacesAndNewlines) != "" else { return nil }
		return t
	}

}
