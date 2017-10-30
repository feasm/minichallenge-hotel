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
    
    func setup(gameScene: GuestManagerDelegate) {
        GuestManager.shared.setup(gameScene: gameScene, maxGuestsSpawn: 10)
        
        self.createPlayers()
    }
}
