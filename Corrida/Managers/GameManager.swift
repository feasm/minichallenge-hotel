//
//  GameManager.swift
//  Corrida
//
//  Created by Felipe Melo on 11/22/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import UIKit
import SpriteKit

class GameManager {
    static let shared: GameManager = GameManager()
    static let MULTIPLAYER_ON: Bool = false
    
    var teleporters : [Teleporter] = []
    
    var localPlayer: Player!
    var localNumber: Int!
    
    var players = [Player]()
    var isHost: Bool = false
    
    private init() {
        
    }
}

// MARK: Teleporters

extension GameManager
{
    func getTeleporter(from: Teleporter) -> CGPoint
    {
        var temp : [Teleporter] = []
        for t in teleporters where t.teleporter == from.teleporter
        {
            temp.append(t)
        }
        
        if temp.count > 0
        {
            let t = temp.chooseOne
            return t.position
        }
        else
        {
            return from.position
        }
    }
}
