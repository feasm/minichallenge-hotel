//
//  GameManager.swift
//  Corrida
//
//  Created by Felipe Melo on 11/22/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import Foundation

class GameManager {
    static let shared: GameManager = GameManager()
    static let MULTIPLAYER_ON: Bool = true
    
    var localPlayer: Player!
    var localNumber: Int!
    
    var players = [Player]()
    var isHost: Bool = false
    
    private init() {
        
    }
}
