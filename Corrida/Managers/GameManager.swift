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
    
    var gameView: SKView?
    
    private init() {
        
    }
    
    func movePlayer(name: String, position: CGPoint, rotation: CGFloat) {
        var playerToMove: Player?
        
        for player in self.players {
            if player.alias == name {
                player.position = position
                player.setRotation(to: rotation)
                break
            }
        }
    }
    
    func destroyPlayer(name: String) {
        for player in self.players {
            if player.alias == name {
                player.destroyPlayer(reason: .HIT_OTHER_PLAYER)
                break
            }
        }
    }
    
    // TODO: Implementar se o rastro ficar desinronizado
    func createPath() {
        
    }
}

// MARK: GameView
extension GameManager {
    func createGameView(view: UIView) -> SKView {
        guard gameView == nil else {
            return gameView!
        }
        
        gameView = SKView(frame: view.frame)
        gameView!.ignoresSiblingOrder = false
        gameView!.showsFPS = true
        gameView!.showsNodeCount = true
        gameView!.showsPhysics = false
        
        return gameView!
    }
    
    func loadScene(sceneName: String) {
        guard gameView != nil else {
            print("gameView não instanciada, impossível carregar uma cena")
            return
        }
        
        let scene = GameScene(fileNamed: "GameScene")!
        scene.scaleMode = .aspectFill
        gameView!.presentScene(scene)
    }
    
    func destroyGameView() {
        guard gameView != nil else {
            print("gameView não instanciada, não pode ser removida")
            return
        }
        
        gameView!.removeFromSuperview()
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
