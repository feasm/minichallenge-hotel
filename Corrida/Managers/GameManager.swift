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
    static let MULTIPLAYER_ON: Bool = true
    
    var teleporters : [Teleporter] = []
    
    var localPlayer: Player!
    var localNumber: Int!
    var playerNumberToWatch: Int = 0
    
    var players = [Player]()
    var isHost: Bool = false
    
    var gameView: GameViewController?
    
    private init() {
        
    }
    
    func movePlayer(name: String, position: CGPoint, rotation: CGFloat) {
        for player in self.players {
            if player.alias == name {
                player.position = position
                player.setRotation(to: rotation)
                break
            }
        }
    }
    
    func destroyPlayer(name: String, reason: DeathReason, defeat: String?) {
        var playerDestroyed: Player?
        var defeatedBy: Player?
        
        for player in self.players {
            if player.alias == name {
                playerDestroyed = player
            } else if defeat != nil && defeat == player.alias {
                defeatedBy = player
            }
        }
        
        if let player = playerDestroyed {
            player.destroyPlayer(reason: reason, defeat: defeatedBy)
        }
    }
    
    func findPlayerBy(alias: String) -> Player?
    {
        for player in players
        {
            if player.alias == alias
            {
                return player
            }
        }
        
        return nil
    }
    
    // TODO: Implementar se o rastro ficar desinronizado
    func createPath() {
        
    }
    
    func findPlayerToWatch(offset: Int) -> Player? {
        var index = 0
        
        repeat {
            playerNumberToWatch += offset
            if playerNumberToWatch >= GameManager.shared.players.count {
                playerNumberToWatch = 0
            } else if playerNumberToWatch < 0 {
                playerNumberToWatch = GameManager.shared.players.count - 1
            }
            
            index += 1
            
            if index > GameManager.shared.players.count {
                return nil
            }
        } while(GameManager.shared.players[playerNumberToWatch].destroyed)
        
        return GameManager.shared.players[playerNumberToWatch]
    }
}

// MARK: GameView
extension GameManager {
    func createGameView(view: UIView) -> GameViewController {
        guard gameView == nil else {
            return gameView!
        }
        
        gameView = GameViewController()
        return gameView!
    }
    
    func destroyGameView() {
        guard gameView != nil else {
            print("gameView não instanciada, não pode ser removida")
            return
        }
        
        gameView!.dismiss(animated: true, completion: nil)
        gameView = nil
    }
    
    func getPlayersScore() -> [Player] {
        return GameManager.shared.players.sorted(by: { (player1, player2) -> Bool in
            let timePlayer1 = player1.getFullTime()
            
            let timePlayer2 = player2.getFullTime()
            
            if timePlayer1 == timePlayer2 {
                return player1.lives() > player2.lives()
            } else {
                return timePlayer1 > timePlayer2
            }
        })
    }
}

// MARK: Teleporters

extension GameManager
{
    func getTeleporter(from: Teleporter) -> CGPoint
    {
        var temp : [Teleporter] = []
        for t in teleporters where (t.teleporter == from.teleporter && t != from)
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
