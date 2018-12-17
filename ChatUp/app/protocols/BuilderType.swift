//
//  BuilderType.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import UIKit

class BuilderType<V: UIViewController & CreatedFromNib, D: DependencyType> {
    
    weak var view: V!
    
    init() {
    }
    
	func build(_ dependency: D) -> V {
		self.view = V.create()
        return view
    }
    
}
