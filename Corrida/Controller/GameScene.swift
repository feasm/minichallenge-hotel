//
//  GameScene.swift
//  Corrida
//
//  Created by Felipe Melo on 11/22/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

enum PlayerDirection {
    case UP
    case DOWN
    case LEFT
    case RIGHT
    case NONE
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var localPlayer: Player!
    var players = [Player]()
    var playerDirection: PlayerDirection = .NONE
    
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var buttonPressed: Bool = false
    
    override func sceneDidLoad() {
        // Carrega Personagens
        self.localPlayer = self.childNode(withName: "Player") as! Player
        self.localPlayer.setup(alias: "Eu")
        self.localPlayer.name = self.localPlayer.alias
        self.players.append(localPlayer)
        
        // Carrega botões do controle
        self.leftButton = self.childNode(withName: "LeftButton") as! SKSpriteNode
        self.rightButton = self.childNode(withName: "RightButton") as! SKSpriteNode
        
        // Inicia a física do mundo
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.view?.showsPhysics = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            
            if self.leftButton.contains(location) {
                self.leftButton.color = UIColor.black
                self.playerDirection = .LEFT
                self.buttonPressed = true
            }
            
            if self.rightButton.contains(location) {
                self.rightButton.color = UIColor.black
                self.playerDirection = .RIGHT
                self.buttonPressed = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.leftButton.color = #colorLiteral(red: 0.4251180291, green: 0.5195503831, blue: 1, alpha: 1)
        self.rightButton.color = #colorLiteral(red: 0.4251180291, green: 0.5195503831, blue: 1, alpha: 1)
        self.buttonPressed = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        localPlayer.update(direction: self.playerDirection)
        
        if !self.buttonPressed {
            self.playerDirection = .NONE
        }
        
        for player in self.players {
            
        }
    }
}

// Physics
extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
//        if contact.bodyA.node?.name == "Path" {
//            contact.bodyB.node?.removeFromParent()
//        } else if contact.bodyB.node?.name == "Path" {
//            contact.bodyA.node?.removeFromParent()
//        }
    }
}
