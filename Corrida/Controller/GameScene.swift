//
//  GameScene.swift
//  Corrida
//
//  Created by Felipe Melo on 11/22/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

enum NodesZPosition : CGFloat
{
    case CONTROLLERS = 20
    case PLAYER = 11
    case PLAYER_SHADOW = 10
    case PLAYER_TRAIL = 9
    case ASSETS = 8
    case BACKGROUND = 7
}

enum PlayerDirection {
    case UP
    case DOWN
    case LEFT
    case RIGHT
    case NONE
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var localPlayer: Player!
    var playerToWatch: Player?
    //var players = [Player]()
    var playerDirection: PlayerDirection = .NONE
    var collisionTypes : [UInt32 : CollisionType] = [:]
    
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var buttonPressed: Bool = false
    var hitlist : Hitlist?
    var endGameModal : EndGameModal?
    
    var miniMap : Minimap!
    var countdownLabel : UILabel?
    
    var spawners : [Int: Spawner?] = [:]
    
    var livesNodes : [SKSpriteNode] = []
    //var teleporters : [Teleporter] = []
    var effects : [Effect] = []
    
    var background : SKSpriteNode!
    
    var gameEnded: Bool = false
    
    override func sceneDidLoad() {
        // Carrega todos os elementos do mapa para poderem ser utilizados no código
        loadChildren()
        loadEffects()
        
        // Carrega Personagens
        if !GameManager.MULTIPLAYER_ON {
            self.localPlayer = Player(type: .FIRST)
            self.localPlayer.setup(id: "0", alias: "Eu")
            self.localPlayer.name = self.localPlayer.alias
            GameManager.shared.players.append(localPlayer)
            addChild(self.localPlayer)
            self.setSpawn(to: self.localPlayer, id: 0)
            
//            let player = Player(type: .THIRD)
//            player.zPosition = 80
//            //player.setup(id: "1", alias: "batata")
//            GameManager.shared.players.append(player)
//            setSpawn(to: player, id: 1)
//            addChild(player)
            
        } else {
            self.localPlayer = GameManager.shared.localPlayer
            self.localPlayer.name = self.localPlayer.alias
            
            var id = 0
            for player in GameManager.shared.players {
                player.setup(id: String(id), alias: player.alias)
                player.updateName()
                player.removeFromParent()
                addChild(player)
                self.setSpawn(to: player, id: id)
                id += 1
//                self.players.append(player)
            }
        }
        
        countDown()
        
        // Carrega botões do controle
        if let camera = self.camera
        {
            camera.setScale(0.9)
            self.leftButton = camera.childNode(withName: "LeftButton") as! SKSpriteNode
            self.leftButton.zPosition = NodesZPosition.CONTROLLERS.rawValue
            self.rightButton = camera.childNode(withName: "RightButton") as! SKSpriteNode
            self.rightButton.zPosition = NodesZPosition.CONTROLLERS.rawValue
            camera.zPosition = NodesZPosition.CONTROLLERS.rawValue+1
        }
        
        // Inicia a física do mundo
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.background.frame)
        self.physicsBody?.restitution = 0.6
        self.physicsBody?.categoryBitMask = PhysicsCategory.WALL.rawValue
        self.name = "Scene"
        self.view?.showsPhysics = true
        
        
        miniMap = Minimap(scene: self)
        miniMap.configure(at: CGPoint(x: 0, y: -370), scale: 0.22)
        
        collisionTypes = [
        PhysicsCategory.WALL.rawValue : .WALL,
        PhysicsCategory.BARRIER.rawValue : .WALL_DESTROY,
        PhysicsCategory.TELEPORT.rawValue : .TELEPORT,
        PhysicsCategory.TRAIL.rawValue : .TRAIL,
        PhysicsCategory.BOOST.rawValue : .BOOST]
        
        gameEnded = false
        
        setupCamera(target: localPlayer)
        
        updateLives()
    }
    
    var countTimer : Int = 1
    
    func respawnPlayer(player: Player)
    {
        if spawners.count > 0
        {
            if player.lives() > 0
            {
                player.respawn = true
                player.destroyed = false
                player.freeze = false
                player.animationLastPoint = nil
                let spawner = Array(spawners.keys).chooseOne
                setSpawn(to: player, id: spawner)
                addChild(player)
                
                player.removeAllActions()
                
                player.run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.run({
                    player.showPath()
                    player.respawn = false
                })]))
            }
        }
    }
    
    func countDown()
    {
        countTimer = 5
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.setCountdown(self.countTimer)
            self.countTimer -= 1
            if self.countTimer < 0
            {
                for player in GameManager.shared.players
                {
                    player.freeze = false
                }
                timer.invalidate()
            }
        }
    }
    
    func updateLives()
    {
        for node in livesNodes
        {
            if let index = livesNodes.index(of: node)
            {
                if index <= (localPlayer.lives()-1)
                {
                    node.alpha = 1
                }
                else
                {
                    node.alpha = 0
                }
            }
        }
    }
    
    func setCountdown(_ pos : Int)
    {
        if let label = self.countdownLabel
        {
            
            let strokeTextAttributes: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey.strokeColor : UIColor.darkGray,
                NSAttributedStringKey.foregroundColor: self.localPlayer.mainColor,
                NSAttributedStringKey.strokeWidth : -1.5]
            label.alpha = 0
            let text = pos != 0 ? String(pos) : "Go!"
            label.attributedText = NSAttributedString(string: text, attributes: strokeTextAttributes)
            
            UIView.animate(withDuration: 0.3, animations: {
                label.alpha = 1
            }) { (_) in
                UIView.animateKeyframes(withDuration: 0.2, delay: 0.5, options: .calculationModeLinear, animations: {
                   label.alpha = 0
                }, completion: nil)
            }
        }
    }
    
    func loadEffects()
    {
        //let type : [EffectType] = [.EXTRA_LIFE, .SPEED, .JUMP, .INVULNERABILITY]
        let type : [EffectType] = [.JUMP]
        for _ in 0...2
        {
            let effect = Effect(type: type.chooseOne, scene: self)
            effects.append(effect)
        }
    }
    
    func loadChildren()
    {
        self.background = self.childNode(withName: "background") as! SKSpriteNode
        self.background.zPosition = NodesZPosition.BACKGROUND.rawValue
        
        GameManager.shared.teleporters.removeAll()
        
        for i in 1...3
        {
            if let camera = camera
            {
                if let node = camera.childNode(withName: "skull_\(i)") as? SKSpriteNode
                {
                    self.livesNodes.append(node)
                }
            }
        }
        
        for child in children
        {
            if let child = child as? Spawner
            {
                spawners[child.getSpawner()] = child
            }
            
            if let child = child as? Barrier
            {
                child.setupPhysics()
            }
            
            if let child = child as? Teleporter
            {
                child.setupPhysics()
                GameManager.shared.teleporters.append(child)
            }
        }
        
    }
    
    func setSpawn(to player: Player, id: Int)
    {
        if spawners[id] != nil, let spawn = spawners[id]!
        {
            player.position = spawn.location()
            player.setRotation(to: spawn.angleTo(.zero))
            //player.rotateByAngle(Float(spawn.angleTo(.zero)))
        }
    }
    
    func updateCamera()
    {
        if GameManager.shared.players.count > 1
        {
            //var distance = 100000
            for player in GameManager.shared.players where player != localPlayer
            {
                let distance = localPlayer.position.distance(to: player.position)
                if distance < (self.size.height)
                {
                    if let camera = self.camera
                    {
                        if camera.xScale != 1.2
                        {
                            camera.run(SKAction.scale(to: 1.2, duration: 0.5))
                        }
                        return
                    }
                }
            }
           
            if let camera = self.camera
            {
                if camera.xScale != 0.9
                {
                    camera.run(SKAction.scale(to: 0.9, duration: 0.5))
                }
            }
        }
    }
    
    func setupCamera(target: SKSpriteNode)
    {
        guard let camera = camera
        else {
            return
        }
        
        let xRange = SKRange(lowerLimit: -background.frame.size.width/2 + (self.size.width/2)*camera.xScale, upperLimit: background.frame.size.width/2 - (self.size.width/2)*camera.xScale)
        let yRange = SKRange(lowerLimit: -background.frame.size.height/2 + (self.size.height/2)*camera.yScale, upperLimit: background.frame.size.height/2 - (self.size.height/2)*camera.yScale)
        
        let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        edgeConstraint.referenceNode = background
        
        let zeroDistance = SKRange(constantValue: 0.0)
        camera.constraints = [SKConstraint.distance(zeroDistance, to: target), edgeConstraint]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self.camera!)
            
            if self.leftButton.contains(location) {
                self.leftButton.color = UIColor.black
                self.playerDirection = .LEFT
                self.buttonPressed = true
                
                if localPlayer.destroyed {
                    playerToWatch = GameManager.shared.findPlayerToWatch(offset: -1)
                }
            }
            
            if self.rightButton.contains(location) {
                self.rightButton.color = UIColor.black
                self.playerDirection = .RIGHT
                self.buttonPressed = true
                
                if localPlayer.destroyed {
                    playerToWatch = GameManager.shared.findPlayerToWatch(offset: +1)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches {
//            let location = t.location(in: self)
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.leftButton.color = #colorLiteral(red: 0.4251180291, green: 0.5195503831, blue: 1, alpha: 1)
        self.rightButton.color = #colorLiteral(red: 0.4251180291, green: 0.5195503831, blue: 1, alpha: 1)
        self.buttonPressed = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        localPlayer.update(direction: self.playerDirection)
        if GameManager.MULTIPLAYER_ON {
            MultiplayerNetworking.shared.sendPlayerMovement(name: self.localPlayer.alias, position: self.localPlayer.position, rotation: self.localPlayer.rotation)
        }
        
        updateCamera()

        if !localPlayer.destroyed {
            setupCamera(target: localPlayer)
        } else if playerToWatch != nil {
            setupCamera(target: playerToWatch!)
        } else {
            playerToWatch = GameManager.shared.findPlayerToWatch(offset: +1)
        }
        
        miniMap.update(players: GameManager.shared.players)
        
        if !self.buttonPressed {
            self.playerDirection = .NONE
        }
        
        if GameManager.MULTIPLAYER_ON
        {
            var playersDestroyed = GameManager.shared.players.count
            var lastPlayer: Player?
            for player in GameManager.shared.players {
                if player.alias != localPlayer.alias {
                    player.update(direction: .NONE)
                }

                if player.lives() == 0 {
                    playersDestroyed -= 1
                } else {
                    lastPlayer = player
                }
            }
            
            if !gameEnded && playersDestroyed <= 1 {
                lastPlayer?.watch.stop()
                lastPlayer?.times.append((lastPlayer?.watch.durationSeconds())!)
                gameEnded = true
        //            GameManager.shared.destroyGameView()
                let players = GameManager.shared.getPlayersScore()
                self.endGameModal?.isHidden = false
                self.endGameModal?.setup(players: players)
            }
        }
    }
}

// Physics
extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {

//        print(contact.bodyA.categoryBitMask)
//        print(contact.bodyB.categoryBitMask)
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.PLAYER.rawValue {
            if let player = contact.bodyA.node as? Player {
                if player.alias == localPlayer.alias {
                    if let type = collisionTypes[contact.bodyB.categoryBitMask] {
                        let node = contact.bodyB.node
                        player.performCollision(type: type, node: node)
                    }
                }
            }
        }
        
        if contact.bodyB.categoryBitMask == PhysicsCategory.PLAYER.rawValue {
            if let player = contact.bodyB.node as? Player {
                if player.alias == localPlayer.alias {
                    if let type = collisionTypes[contact.bodyA.categoryBitMask] {
                        let node = contact.bodyA.node
                        player.performCollision(type: type, node: node)
                    }
                }
            }
        }

    }
    
    func didEnd(_ contact: SKPhysicsContact) {
       
        if contact.bodyA.categoryBitMask == PhysicsCategory.PLAYER.rawValue {
            if let player = contact.bodyA.node as? Player {
                if let type = collisionTypes[contact.bodyB.categoryBitMask] {
                    let node = contact.bodyB.node
                    player.releaseCollision(type: type, node: node)
                }
            }
        }
        
        if contact.bodyB.categoryBitMask == PhysicsCategory.PLAYER.rawValue {
            if let player = contact.bodyB.node as? Player {
                if let type = collisionTypes[contact.bodyA.categoryBitMask] {
                    let node = contact.bodyA.node
                    player.releaseCollision(type: type, node: node)
                }
            }
        }
    }
}
