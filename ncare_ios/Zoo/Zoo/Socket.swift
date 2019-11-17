//
//  Socket.swift
//  Zoo
//
//  Created by Никита Казанцев on 16.11.2019.
//  Copyright © 2019 sudox.kazantsev.com. All rights reserved.
//

import SwiftUI
import SocketIO
import Combine

let manager = SocketManager(socketURL: URL(string: "ws://45.143.136.60:5000")!, config: [.log(true), .compress])
let socket = manager.defaultSocket


class Socket: ObservableObject {
    let didChange = PassthroughSubject<Socket,Never>()
    
    var isconnected: Bool = false {
        didSet {
            didChange.send(self)
            
        }
    }
    
    static let sharedInstance = Socket()
    
    init() {
        socket.connect()
        
        
    }
    
    func on(clientEvent event: SocketClientEvent, callback: @escaping NormalCallback) -> UUID {
        socket.on(event.rawValue, callback: callback)
    }
    
    func on(_ event: String, callback: @escaping NormalCallback) {
        socket.on(event, callback: callback)
        
    }
    
    func emit(_ event: String, with items: [Any])
    {
        socket.emit(event, items)
    }
    func emit(_ event: String, with items: [String: Any])
    {
        socket.emit(event, items)
    }

    func establishConnection() {
        socket.connect()
    }

    func closeConnection() {
        socket.disconnect()
    }
}
