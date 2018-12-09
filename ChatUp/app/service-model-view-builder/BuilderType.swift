//
//  BuilderType.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation
import UIKit

class BuilderType<V: UIViewController & CreatedFromNib> {
    
    var view: V
    
    init() {
        self.view = V.create()
    }
    
    func build() -> V {
        return view
    }
    
}
