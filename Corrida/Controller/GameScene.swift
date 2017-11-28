//
//  GameScene.swift
//  Corrida
//
//  Created by Felipe Melo on 11/22/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import SpriteKit
import GameplayKit


enum NodesZPosition : CGFloat
{
    case CONTROLLERS = 20
    case PLAYER = 10
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
    var players = [Player]()
    var playerDirection: PlayerDirection = .NONE
    var collisionTypes : [UInt32 : CollisionType] = [:]
    
    var leftButton : SKSpriteNode!
    var rightButton : SKSpriteNode!
    var buttonPressed : Bool = false
    var isZooming : Bool = false
    
    var spawners : [Int: Spawner?] = [:]
    //var teleporters : [Teleporter] = []
    
    var background : SKSpriteNode!
    
    var miniMap : Minimap!
    
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
            self.localPlayer.name = self.localPlayer.alias
            
            var id = 0
            for player in GameManager.shared.players {
                player.removeFromParent()
                addChild(player)
                self.setSpawn(to: player, id: id)
                id += 1
                
//                self.players.append(player)
            }
        }
        
        let player = Player(type: "dogalien")
        player.zPosition = 80
        //player.setup(id: "1", alias: "batata")
        self.players.append(player)
        setSpawn(to: player, id: 1)
        addChild(player)
        
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
        PhysicsCategory.TRAIL.rawValue : .TRAIL]
        
        setupCamera(target: localPlayer)
    }
    
    func loadChildren()
    {
        self.background = self.childNode(withName: "background") as! SKSpriteNode
        self.background.zPosition = NodesZPosition.BACKGROUND.rawValue
        
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
            var distance : CGFloat = 0.0
            for player in players where player != localPlayer
            {
                let distanceForPlayer = localPlayer.position.distance(to: player.position)
                if distanceForPlayer > distance
                {
                    distance = distanceForPlayer
                }
            }
            
            if !isZooming && distance < (self.size.height)
            {
                if let camera = self.camera
                {
                    camera.run(SKAction.scale(to: 1.2, duration: 0.8))
//                    {
//                        self.setupCamera(target: self.localPlayer, scale: 1.2)
//                    }
                    isZooming = true
                }

            }
            else if isZooming && distance > (self.size.height)*1.3
            {
                if let camera = self.camera
                {
                    camera.run(SKAction.scale(to: 0.9, duration: 0.8))
//                    {
//                        self.setupCamera(target: self.localPlayer, scale: 0.9)
//                    }
                    isZooming = false
                }
                
            }
        }
    }
    
    func setupCamera(target: SKSpriteNode, scale : CGFloat? = nil)
    {
        guard let camera = camera
        else {
            return
        }
        
        let cameraScale = scale != nil ? scale! : camera.xScale
        
        let xRange = SKRange(lowerLimit: -background.frame.size.width/2 + (self.size.width/2)*cameraScale, upperLimit: background.frame.size.width/2 - (self.size.width/2)*cameraScale)
        let yRange = SKRange(lowerLimit: -background.frame.size.height/2 + (self.size.height/2)*cameraScale, upperLimit: background.frame.size.height/2 - (self.size.height/2)*cameraScale)
        
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
        setupCamera(target: localPlayer)
        
        miniMap.update(players: players)
        
        if !self.buttonPressed {
            self.playerDirection = .NONE
        }
        
        for player in self.players {
            player.update(direction: .NONE)
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
