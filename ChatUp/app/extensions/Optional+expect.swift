//
//  Optional+expect.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

extension Optional {

	func expect(message: String) -> Wrapped {
		switch self {
		case .some(let wrapped):
			return wrapped
		case .none:
			fatalError(message)
		}
	}


}
