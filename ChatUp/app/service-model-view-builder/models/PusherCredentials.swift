//
//  PusherCredentials.swift
//  ChatUp
//
//  Created by Mark on 09/12/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import Foundation

struct PusherCredentials: Decodable {
    let id: String
    let key: String
    let secret: String
    let cluster: String
    let channel: String
}

extension PusherCredentials {
    
    static let `default`: PusherCredentials = PusherCredentials.create(fromJSONFileWithName: "pusher_credentials")

    static func create(fromJSONFileWithName name: String) -> PusherCredentials {
        guard let file = Bundle.main.path(forResource: name, ofType: "json") else {
            fatalError("Unable to find \(name).json in bundle.")
        }
        let jsonString = try! String(contentsOfFile: file)
        let jsonData = jsonString.data(using: .utf8)
        return try! JSONDecoder().decode(PusherCredentials.self, from: jsonData!)
    }
    
}
