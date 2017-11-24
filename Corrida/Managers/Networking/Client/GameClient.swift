//
//  GameClient.swift
//  gameChallenge
//
//  Created by Felipe Melo on 10/30/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//
import Foundation

class GameClient: GameNetworkingMixin {
    // Constants
    static let shared: GameClient = GameClient()
    
    private override init() {
        super.init()
    }
    
    func setup(_ playerNames: [String]) {
        self.mapPlayers(playerNames)
        GameKitHelper.shared.startViewController?.matchStarted()
    }
}
