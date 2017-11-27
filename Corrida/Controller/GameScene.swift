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
    var collisionTypes : [UInt32 : CollisionType] = [:]
    
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var buttonPressed: Bool = false
    
    var spawners : [Int: Spawner?] = [:]
    //var teleporters : [Teleporter] = []
    
    var background : SKSpriteNode!
    
    override func sceneDidLoad() {
        // Carrega todos os elementos do mapa para poderem ser utilizados no código
        loadChildren()
        
        // Carrega Personagens
        if !GameManager.MULTIPLAYER_ON {
            self.localPlayer = Player(type: "dogalien") //self.childNode(withName: "Player") as! Player
            self.localPlayer.setup(id: "0", alias: "Eu")
            self.localPlayer.name = self.localPlayer.alias
            self.players.append(localPlayer)
            addChild(self.localPlayer)
            self.setSpawn(to: self.localPlayer, id: 0)
        } else {
            self.localPlayer = GameManager.shared.localPlayer
//            self.localPlayer.setType(type: "dogalien")
            self.localPlayer.name = self.localPlayer.alias
//            self.localPlayer.removeFromParent()
//            self.addChild(self.localPlayer)
            
            var id = 0
            for player in GameManager.shared.players {
//                player.setType(type: "dogalien")
//                player.setup(id: String(id), alias: player.alias)
//                player.setPhysics()
                player.removeFromParent()
                addChild(player)
                self.setSpawn(to: player, id: id)
                id += 1
            }
        }
        
//        let player = Player(texture: nil, color: .yellow, size: CGSize(width: 100, height: 100))
//        player.setup(alias: "batata")
//        self.players.append(player)
//        setSpawn(to: player, id: 1)
//        addChild(player)
        
        // Carrega botões do controle
        if let camera = self.camera
        {
            camera.setScale(1)
            self.leftButton = camera.childNode(withName: "LeftButton") as! SKSpriteNode
            self.rightButton = camera.childNode(withName: "RightButton") as! SKSpriteNode
        }
        // Inicia a física do mundo
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.background.frame)
        self.physicsBody?.categoryBitMask = PhysicsCategory.WALL.rawValue
        self.name = "Scene"
        self.view?.showsPhysics = true
        
        collisionTypes =
        [PhysicsCategory.WALL.rawValue : .WALL,
        PhysicsCategory.BARRIER.rawValue : .WALL_DESTROY,
        PhysicsCategory.TELEPORT.rawValue : .TELEPORT]
        
        setupCamera(target: localPlayer)
    }
    
    func loadChildren()
    {
        self.background = self.childNode(withName: "background") as! SKSpriteNode
        
        GameManager.shared.teleporters.removeAll()
        
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
        if players.count > 1
        {
            //var distance = 100000
            for player in players where player != localPlayer
            {
                let distance = localPlayer.position.distance(to: player.position)
                if distance < (self.size.height/2)
                {
                    if let camera = self.camera
                    {
                        camera.run(SKAction.scale(to: 1, duration: 1))
                        return
                    }
                }
            }
           
            if let camera = self.camera
            {
                camera.run(SKAction.scale(to: 0.6, duration: 1))
            }
        }
    }
    
    func setupCamera(target: SKSpriteNode)
    {
        guard let camera = camera
        else {
            return
        }
        
        let xRange = SKRange(lowerLimit: -background.frame.size.width/2 + self.size.width/2, upperLimit: background.frame.size.width/2 - self.size.width/2)
        let yRange = SKRange(lowerLimit: -background.frame.size.height/2 + self.size.height/2, upperLimit: background.frame.size.height/2 - self.size.height/2)
        
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
            }
            
            if self.rightButton.contains(location) {
                self.rightButton.color = UIColor.black
                self.playerDirection = .RIGHT
                self.buttonPressed = true
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
        
        updateCamera()
        
        if !self.buttonPressed {
            self.playerDirection = .NONE
        }
        
//        for player in self.players {
//
//        }
    }
}

// Physics
extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {

//        print(contact.bodyA.categoryBitMask)
//        print(contact.bodyB.categoryBitMask)
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.PLAYER.rawValue {
            if let player = contact.bodyA.node as? Player {
                if let type = collisionTypes[contact.bodyB.categoryBitMask] {
                    let node = contact.bodyB.node
                    player.performCollision(type: type, node: node)
                }
            }
        }
        
        if contact.bodyB.categoryBitMask == PhysicsCategory.PLAYER.rawValue {
            if let player = contact.bodyB.node as? Player {
                if let type = collisionTypes[contact.bodyA.categoryBitMask] {
                    let node = contact.bodyA.node
                    player.performCollision(type: type, node: node)
                }
            }
        }
        
        //print(contact.bodyA.node?.name ?? "Body A")
        //print(contact.bodyB.node?.name ?? "Body B")
//        if contact.bodyA.node?.name == "Path" {
//            contact.bodyB.node?.removeFromParent()
//        } else if contact.bodyB.node?.name == "Path" {
//            contact.bodyA.node?.removeFromParent()
//        }
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
