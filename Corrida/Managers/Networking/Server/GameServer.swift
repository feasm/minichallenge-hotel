//
//  Server.swift
//  gameChallenge
//
//  Created by Felipe Melo on 10/30/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//
import Foundation

class GameServer: GameNetworkingMixin {
    // Constants
    static let shared: GameServer = GameServer()
    
    private override init() {
        super.init()
    }
    
    func setup() {
        GameManager.shared.isHost = true
        
        self.mapPlayers()
    }
}

// MARK: GuestMethods
extension GameServer {
//    func sendGuestData(target: Target, state: PlayerState, guestIndex: Int) {
//        let gameData = GameData(messageType: .GUEST_MESSAGE, name: nil, target: target, state: state, guestIndex: guestIndex, centerPoint: nil)
//        let dataStr = self.encodeData(gameData: gameData)
//
//        self.networkingEngine.sendData(data: Data(base64Encoded: dataStr.toBase64())!)
//    }
}
