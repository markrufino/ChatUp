//
//  RootBuilder.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct RootDependency: DependencyType {
	var coordinator: RootCoordinator
}

class RootBuilder: BuilderType<RootViewController, RootDependency> {
    
	override func build(_ dependency: RootDependency) -> RootViewController {
		view.coordinator = dependency.coordinator
        return view
    }

}
