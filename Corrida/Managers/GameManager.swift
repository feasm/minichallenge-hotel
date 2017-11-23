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
    var localPlayer: Player!
    var players = [Player]()
    
    private init() {
        
    }
}
