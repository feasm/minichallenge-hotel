//
//  Player.swift
//  Corrida
//
//  Created by Felipe Melo on 11/22/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import SpriteKit
import UIKit

enum SpriteDirection : String
{
    case SIDE = "side"
    case BACK = "back"
    case FRONT = "front"
    case NONE = "none"
}

public class Stopwatch {
    public init() { }
    private var start_: TimeInterval = 0.0;
    private var end_: TimeInterval = 0.0;
    
    public func start() {
        start_ = NSDate().timeIntervalSince1970;
    }
    
    public func stop() {
        end_ = NSDate().timeIntervalSince1970;
    }
    
    public func durationSeconds() -> TimeInterval {
        return end_ - start_;
    }
}

enum DeathReason: Int, Codable
{
    case HIT_MYSELF = 1
    case HIT_OTHER_PLAYER = 2
    case HIT_WALL = 3
}

class Player: SKSpriteNode {
    static let CONSTANT_SPEED: CGFloat = 500.0
    static let ROTATION_SPEED: Float = 0.05
    static let MAX_LIVES : Int = 3
    
    var id: String!
    var alias: String!
    var playerSpeed: CGVector = CGVector(dx: 0, dy: Player.CONSTANT_SPEED)
    var rotation: CGFloat = 0
    var collide : Bool = false
    var lastTeleporter : Teleporter? = nil
    var lastPosition : CGPoint = .zero
    var tailNodes : [SKShapeNode] = []
    
    var destroyed : Bool = false
    var freeze : Bool = true
    
    var mainColor : UIColor = .white
    
    var animationLastPoint: CGPoint?
    
    var playerNameLabel: SKLabelNode?
    var shadow : SKSpriteNode?
    var mainNode : SKSpriteNode!
    
    var lastDirection : SpriteDirection = .NONE
    var animations : [SpriteDirection : [SKTexture]] = [:]
    var shadows : [SpriteDirection : SKTexture] = [:]
    
    var kills : [Hitkill] = []
    var deaths : [Hitkill] = []
    var times : [TimeInterval] = []
    
    var watch : Stopwatch = Stopwatch()
    var respawn : Bool = false
    
    var characterEnum: CharactersEnum?
    
    func setup(id: String, alias: String) {
        self.id = id
        self.alias = alias
        
        setupPhysics()
        zPosition = NodesZPosition.PLAYER.rawValue
        
        lastPosition = self.position
        self.animationLastPoint = nil
        
        destroyed = false
        respawn = false
        
        restartGame()
    }
    
    init() {
        super.init(texture: nil, color: UIColor.white, size: CGSize(width: 0, height: 0))
        zPosition = NodesZPosition.PLAYER.rawValue
    }
    
    init(type: CharactersEnum) {
        super.init(texture: nil, color: .clear, size: CGSize(width: 300, height: 300))
        self.setupMainNode(type: type)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update(direction: PlayerDirection) {
        self.setDirection(direction)
        self.updateDirection()
        self.setSpeed()
    }
    
    func updateName() {
        if playerNameLabel == nil {
            playerNameLabel = SKLabelNode(fontNamed: "Arial")
            playerNameLabel!.text = self.alias
            playerNameLabel!.fontColor = SKColor.white
            playerNameLabel!.fontSize = 50
            playerNameLabel!.position = CGPoint(x: 0, y: self.frame.size.height + 10)
            self.addChild(playerNameLabel!)
        }
    }
    
    func setupMainNode(type: CharactersEnum)
    {
        mainNode = SKSpriteNode(color: .clear, size: self.size)
        mainNode.position = CGPoint(x: 0, y: 0)
        mainNode.zPosition = 1
        mainNode.alpha = 1
        
        self.addChild(mainNode)
        
        let rotate : CGFloat = CGFloat(3.0).radians
        let up_down = SKAction.sequence([SKAction.rotate(byAngle: rotate, duration: 1), SKAction.rotate(byAngle: -(rotate*2), duration: 2), SKAction.rotate(byAngle: rotate, duration: 1)])
        up_down.timingMode = .linear
        self.mainNode.run(SKAction.repeatForever(up_down), withKey: "updown_animation")

        setupShadow()
        
        self.setType(type: type)
    }
    
    func setupShadow()
    {
        if shadow == nil
        {
            shadow = SKSpriteNode(color: .black, size: CGSize(width: 100, height: 100))
            shadow?.position = CGPoint(x: 0, y: -160)
            shadow?.zPosition = -1
            shadow?.alpha = 0.5
            shadow?.setScale(0.8)
            
            let actions = SKAction.sequence([SKAction.scale(to: 0.8, duration: 1), SKAction.scale(to: 1, duration: 2), SKAction.scale(to: 0.8, duration: 2), SKAction.scale(to: 1, duration: 1)])
            actions.timingMode = .linear
            shadow?.run(SKAction.repeatForever(actions), withKey: "shadow_animation")
            self.addChild(shadow!)
        }
    }
    
    
    func setDirection(_ direction: PlayerDirection) {
        switch(direction) {
            case .LEFT:
                self.rotateByAngle(Player.ROTATION_SPEED)
            case .RIGHT:
                self.rotateByAngle(-Player.ROTATION_SPEED)
            default:
                return
        }
        
        self.setSpeed()
    }
    

    func destroyPlayer(reason: DeathReason, defeat: Player? = nil)
    {
        if !destroyed
        {
            destroyed = true
            if let scene = scene as? GameScene
            {
                respawn = true
                watch.stop()
                self.times.append(watch.durationSeconds())
                let hit = Hitkill(victim: self, reason: reason, killer: defeat)
                self.deaths.append(hit)
                if defeat != nil
                {
                    defeat?.kills.append(hit)
                }
                scene.hitlist?.addHit(hit: hit)
                scene.updateLives()
                self.removeFromParent()
                removeAllActions()
                
                self.destroyPath()
                scene.respawnPlayer(player: self)

//                removeAllActions()
                
                
            }
        }
    }
    
    func lives() -> Int
    {
        return (Player.MAX_LIVES - deaths.count)
    }
    
    func restartGame()
    {
        freeze = true
        watch.start()
        deaths.removeAll()
        kills.removeAll()
        times.removeAll()
    }

    func setType(type: CharactersEnum) {
        
        var prefix = ""
        
        self.characterEnum = type
        switch type {
        case .FIRST: //Dogalien
            prefix = "dogalien"
            mainColor = .pColorDog
        case .SECOND: //Bird
            prefix = "alienbird"
            mainColor = .pColorBird
        case .THIRD: //Gosma
            prefix = "gooalien"
            mainColor = .pColorGoo
        case .FORTH: //Demon
            prefix = "demonalien"
            mainColor = .pColorDemon
//        default:
//            prefix = "dogalien"
        }
        
        
        
        var textureName = "\(prefix)_\(SpriteDirection.FRONT.rawValue)"
        animations[.FRONT] = [SKTexture(imageNamed: textureName)]
        shadows[.FRONT] = SKTexture(imageNamed: "shadow_\(SpriteDirection.FRONT.rawValue)")
        
        textureName = "\(prefix)_\(SpriteDirection.SIDE.rawValue)"
        animations[.SIDE] = [SKTexture(imageNamed: textureName)]
        shadows[.SIDE] = SKTexture(imageNamed: "shadow_\(SpriteDirection.SIDE.rawValue)")
        
        textureName = "\(prefix)_\(SpriteDirection.BACK.rawValue)"
        animations[.BACK] = [SKTexture(imageNamed: textureName)]
        shadows[.BACK] = SKTexture(imageNamed: "shadow_\(SpriteDirection.BACK.rawValue)")
        
        let texture = (animations[.FRONT]?.first)!
        mainNode.texture = texture
        mainNode.run(SKAction.setTexture(texture, resize: true))
        
        self.mainNode.setScale(0.8)
    }
    
    func getFullTime() -> Int {
        return Int(self.times.reduce(0, { (result, value) -> Double in
            return result + value
        }))
    }
}

// MARK: Player Physics
extension Player {
    func setupPhysics() {
        self.showPath()
        self.setPhysics()
    }
    
    func setPhysics() {
        //self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
//        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        if let texture = mainNode.texture
        {
            self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size()*CGFloat(0.6))
        }
        else
        {
            self.physicsBody = SKPhysicsBody(circleOfRadius: (self.size.width/2)*CGFloat(0.6))
        }
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 0
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.PLAYER.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.WALL.rawValue | PhysicsCategory.BARRIER.rawValue
        self.physicsBody!.contactTestBitMask = PhysicsCategory.WALL.rawValue | PhysicsCategory.BARRIER.rawValue | PhysicsCategory.TELEPORT.rawValue | PhysicsCategory.TRAIL.rawValue
        
        self.setSpeed()
    }
    
    func setPosition(_ pos: CGPoint)
    {
        self.run(SKAction.move(to: pos, duration: 0))
    }
    
    func setSpeed() {
        self.physicsBody?.velocity = freeze ? CGVector(dx: 0, dy: 0) : playerSpeed
    }
    
    func invertSpeed()
    {
        self.playerSpeed = self.playerSpeed.invert()
        let angle = atan2(self.playerSpeed.dy, self.playerSpeed.dx)
        self.rotation = angle
    }
    
    func updateAngle()
    {
        let angle = atan2(self.playerSpeed.dy, self.playerSpeed.dx)
        self.rotation = angle
    }
    
    func setRotation(to angle: CGFloat)
    {
        let angle360 = angle.degrees360
    
        let new_angle : CGFloat = angle360 > 360 ? angle360.truncatingRemainder(dividingBy: 360.0) : angle360
        self.rotation = new_angle.radians
        
        let vector = CGPoint.vectorDirection(length: Player.CONSTANT_SPEED, direction: self.rotation.degrees360)
        
        self.playerSpeed = CGVector(dx: vector.x, dy: vector.y)
        
        setSpeed()
    }
    
    func rotateByAngle(_ angle: Float) {
    
        setRotation(to: rotation+CGFloat(angle))
        
        /*
        let ca = cosf(angle)
        let sa = sinf(angle)
        
        self.playerSpeed = CGVector(
            dx: CGFloat(ca) * self.playerSpeed.dx - CGFloat(sa) * self.playerSpeed.dy,
            dy: CGFloat(sa) * self.playerSpeed.dx + CGFloat(ca) * self.playerSpeed.dy
        )
        
        let angle = atan2(self.playerSpeed.dy, self.playerSpeed.dx)
        //self.zRotation = angle
        self.rotation = angle
        
        setSpeed()*/
    }
}


extension Player
{
    func updateDirection()
    {
        if animations.count > 0
        {
            let angle = self.rotation.degrees360
            let angle_range : CGFloat = 40.0
            
            var direction : SpriteDirection = .NONE
            var flipped = 1
            
            if angle.inBetween(0, angle_range) || angle.inBetween(360-angle_range, 360)
            {
                direction = .SIDE
                flipped = 1
            }
            else if angle.inBetween(angle_range, 180-angle_range)
            {
                direction = .BACK
                if angle.inBetween(angle_range, (180-angle_range)/2.0)
                {
                    flipped = 1
                }
                else
                {
                    flipped = -1
                }
            }
            else if angle.inBetween(180-angle_range, 180+(2.0 * angle_range))
            {
                direction = .SIDE
                flipped = -1
            }
            else if angle.inBetween(180+(2.0 * angle_range), 360-angle_range)
            {
                direction = .FRONT
                flipped = 1
            }
            
            
            if lastDirection != direction && direction != .NONE
            {
                if let animate = self.animations[direction]
                {
                    self.mainNode.run(SKAction.animate(with: animate, timePerFrame: 0.4), withKey: "animation")
                }
                
                if let shadow = self.shadows[direction]
                {
                    self.shadow?.run(SKAction.setTexture(shadow, resize: true))
                }
                lastDirection = direction
            }
            
            let scaleSign = Int(self.mainNode.xScale).signum()
            if flipped != scaleSign
            {
                self.mainNode.xScale = CGFloat(flipped)*abs(self.mainNode.xScale)
            }
            
            self.playerNameLabel?.xScale = xScale
        }
    }
    
//    func updateDirection()
//    {
//        if animations.count > 0
//        {
//            var angle = self.rotation.degrees360
//            let angle_range : CGFloat = 40.0
//
//            var direction : SpriteDirection =
//            var flipped = -1
//
//            if sign(mainNode.xScale)
//
//            if angle.inBetween(0, angle_range) || angle.inBetween(360-angle_range, 360)
//            {
//                direction =
//                if let animate = self.animations[.SIDE]
//                {
//                    //                    self.mainNode.run(SKAction.animate(with: animate, timePerFrame: 0.4, resize: true, restore: false), withKey: "animation")
//                    self.mainNode.run(SKAction.animate(with: animate, timePerFrame: 0.4), withKey: "animation")
//                    self.mainNode.xScale = abs(self.mainNode.xScale)
//                }
//
//                if let shadow = self.shadows[.SIDE]
//                {
//                    self.shadow?.run(SKAction.setTexture(shadow, resize: true))
//                    //                    self.shadow?.texture = shadow
//                }
//            }
//            else if angle.inBetween(angle_range, 180-angle_range)
//            {
//                if let animate = self.animations[.BACK]
//                {
//                    //                    self.mainNode.run(SKAction.animate(with: animate, timePerFrame: 0.4, resize: true, restore: false), withKey: "animation")
//                    self.mainNode.run(SKAction.animate(with: animate, timePerFrame: 0.4), withKey: "animation")
//                    if angle.inBetween(angle_range, (180-angle_range)/2.0)
//                    {
//                        self.mainNode.xScale = abs(self.mainNode.xScale)
//                    }
//                    else
//                    {
//                        self.mainNode.xScale = -abs(self.mainNode.xScale)
//                    }
//                }
//
//                if let shadow = self.shadows[.BACK]
//                {
//                    //                    self.shadow?.texture = shadow
//                    self.shadow?.run(SKAction.setTexture(shadow, resize: true))
//                }
//            }
//            else if angle.inBetween(180-angle_range, 180+(2.0 * angle_range))
//            {
//                if let animate = self.animations[.SIDE]
//                {
//                    //                    self.mainNode.run(SKAction.animate(with: animate, timePerFrame: 0.4, resize: true, restore: false), withKey: "animation")
//                    self.mainNode.run(SKAction.animate(with: animate, timePerFrame: 0.4), withKey: "animation")
//                    self.mainNode.xScale = -abs(self.mainNode.xScale)
//                }
//
//                if let shadow = self.shadows[.SIDE]
//                {
//                    //                    self.shadow?.texture = shadow
//                    self.shadow?.run(SKAction.setTexture(shadow, resize: true))
//                }
//            }
//            else if angle.inBetween(180+(2.0 * angle_range), 360-angle_range)
//            {
//                if let animate = self.animations[.FRONT]
//                {
//                    //                    self.mainNode.run(SKAction.animate(with: animate, timePerFrame: 0.4, resize: true, restore: false), withKey: "animation")
//                    self.mainNode.run(SKAction.animate(with: animate, timePerFrame: 0.4), withKey: "animation")
//                }
//
//                if let shadow = self.shadows[.FRONT]
//                {
//                    self.shadow?.run(SKAction.setTexture(shadow, resize: true))
//                }
//            }
//
//            self.playerNameLabel?.xScale = xScale
//        }
//    }
}

enum CollisionType
{
    case WALL
    case WALL_DESTROY
    case TELEPORT
    case TRAIL
    case NONE
}


// MARK: Player Collisions

extension Player {
    
    func releaseCollision(type : CollisionType, node: SKNode? = nil)
    {
        guard !freeze else { return }
        
        switch type {
        case .TELEPORT:
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (_) in
                self.lastTeleporter = nil
            })
        default:
            return
        }
    }
    
    func performCollision(type : CollisionType, node: SKNode? = nil)
    {
        guard !freeze else { return }
        
        //print(type)
        switch type {
        case .TRAIL:
            if !destroyed && lastTeleporter == nil
            {
                if let node = node
                {
                    if node.name == self.alias
                    {
                        destroyPlayer(reason: .HIT_MYSELF)
                        MultiplayerNetworking.shared.sendPlayerDestroyed(name: self.alias, reason: .HIT_MYSELF, defeat: nil)
                    }
                    else
                    {
                        let killer = GameManager.shared.findPlayerBy(alias: node.name ?? "nonalias")
                        destroyPlayer(reason: .HIT_OTHER_PLAYER, defeat: killer)
                        MultiplayerNetworking.shared.sendPlayerDestroyed(name: self.alias, reason: .HIT_OTHER_PLAYER, defeat: killer?.alias)
                    }
                }
            }
        case .TELEPORT:
            
            if let node = node as? Teleporter
            {
                if lastTeleporter == nil
                {
                    lastTeleporter = node
                    let pos = GameManager.shared.getTeleporter(from: node)
                    print("Teleporter at:", pos)
                    setPosition(pos)
                    self.animationLastPoint = nil
                }
            }
        case .WALL_DESTROY:
//            print("Destroy:", alias)
            destroyPlayer(reason: .HIT_WALL)
            MultiplayerNetworking.shared.sendPlayerDestroyed(name: self.alias, reason: .HIT_WALL, defeat: nil)
        case .WALL:
            if !collide {
                collide = true
//                let newAngle = (90-self.rotation.degrees) + 90
//                print(self.rotation.degrees, newAngle.degrees)
//                setRotation(to: newAngle.radians)
//                setSpeed()
//                invertSpeed()
//                setSpeed()
                self.playerSpeed = (self.physicsBody?.velocity)!
                self.updateAngle()
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { (_) in
                    
                    self.collide = false
                })
            }
        default:
            return
        }
    }
}

// MARK: Player Path
extension Player {
    
    func destroyPath()
    {
        for node in tailNodes
        {
            node.physicsBody = nil
            node.removeFromParent()
        }
        tailNodes.removeAll()
    }
    
    func showPath() {
        let smoothPath = SKAction.run({
            if self.lastTeleporter == nil && !self.freeze && !self.destroyed && !self.respawn
            {
                if self.lastPosition.distance(to: self.position) > 10
                {
                    self.lastPosition = self.position
//                    let path = CGMutablePath()
                    if self.animationLastPoint == nil {
                        self.animationLastPoint = CGPoint(x: self.position.x, y: self.position.y)
                    }
//                    path.move(to: self.animationLastPoint!)
//                    path.addLine(to: self.position)
//
//                    let node = SKShapeNode(path: path)
//                    node.strokeColor = self.mainColor //#colorLiteral(red: 0.6987038255, green: 0.9717952609, blue: 0.4537590742, alpha: 1)
//                    node.lineWidth = 40
//                    node.zPosition = self.zPosition - 1
                    
                    let node = SKSpriteNode(imageNamed: "fire")
                    node.zPosition = self.zPosition - 1
                    node.position = self.position
                    node.setScale(2)
                    
//                    self.tailNodes.append(node)
                    
                    self.scene?.addChild(node)
                    let wait = SKAction.wait(forDuration: 3)
                    let fadeOut = SKAction.fadeOut(withDuration: 1)
                    let remove = SKAction.group([SKAction.removeFromParent(), SKAction.run {
//                        self.tailNodes.removeFirst()
                    }])
                    
                    let waitPhysics = SKAction.wait(forDuration: 0.5)
                    let trailPhysics = SKAction.run {
                        node.physicsBody = SKPhysicsBody(circleOfRadius: 50)
                        //node.physicsBody = SKPhysicsBody(polygonFrom: path) //SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
                        node.physicsBody?.isDynamic = true
                        node.physicsBody?.friction = 0
                        node.physicsBody?.restitution = 0
                        node.physicsBody?.categoryBitMask = PhysicsCategory.TRAIL.rawValue
                        node.physicsBody?.collisionBitMask = 0
                        node.physicsBody?.contactTestBitMask = PhysicsCategory.PLAYER.rawValue
                        node.name = self.alias
                    }
                    
                    let actions = SKAction.group([SKAction.sequence([waitPhysics, trailPhysics]), SKAction.sequence([wait, fadeOut, remove])])
                    node.run(actions)
                    
                    self.animationLastPoint = self.position
                }
            }
            
        })

        self.run(SKAction.repeatForever(SKAction.sequence([smoothPath, SKAction.wait(forDuration: 0.25)])))
    }
    
    @objc func setPhysicsOnPath(sender: Any) {
        let node = sender as! SKNode
        
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = PhysicsCategory.TRAIL.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = PhysicsCategory.PLAYER.rawValue
        node.name = self.alias
    }
}
