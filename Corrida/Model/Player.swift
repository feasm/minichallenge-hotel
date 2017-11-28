//
//  Player.swift
//  Corrida
//
//  Created by Felipe Melo on 11/22/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import SpriteKit

enum SpriteDirection : String
{
    case SIDE = "side"
    case BACK = "back"
    case FRONT = "front"
}

class Player: SKSpriteNode {
    static let CONSTANT_SPEED: CGFloat = 500.0
    static let ROTATION_SPEED: Float = 0.05
    
    var id: String!
    var alias: String!
    var playerSpeed: CGVector = CGVector(dx: 0, dy: Player.CONSTANT_SPEED)
    var rotation: CGFloat = 0
    var collide : Bool = false
    var lastTeleporter : Teleporter? = nil
    var lastPosition : CGPoint = .zero
    var destroyed : Bool = false
    
    var animationLastPoint: CGPoint?
    var animationPoints = [SKShapeNode]()
    
    var playerNameLabel: SKLabelNode?
    
    var animations : [SpriteDirection : [SKTexture]] = [:]
    
    enum DeathReason
    {
        case HIT_MYSELF
        case HIT_OTHER_PLAYER
        case HIT_WALL
    }
    
    func setup(id: String, alias: String) {
        self.id = id
        self.alias = alias
        setupPhysics()
        zPosition = NodesZPosition.PLAYER.rawValue
        lastPosition = self.position
        self.animationLastPoint = nil
        destroyed = false
    }
    
    init() {
        super.init(texture: nil, color: UIColor.white, size: CGSize(width: 0, height: 0))
        zPosition = NodesZPosition.PLAYER.rawValue
    }
    
    init(type: String) {
        super.init(texture: nil, color: .white, size: CGSize(width: 300, height: 300))
        self.setType(type: type)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update(direction: PlayerDirection) {
        self.setDirection(direction)
        self.checkCollision()
        self.updateDirection()
        self.setSpeed()
        //print(zRotation)
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
    

    func destroyPlayer(reason: DeathReason)
    {
        print(reason)
        if !destroyed
        {
            destroyed = true
            self.removeFromParent()
        }
    }

    func setType(type: String) {
        var textureName = "\(type)_\(SpriteDirection.FRONT.rawValue)"
        animations[.FRONT] = [SKTexture(imageNamed: textureName)]
        
        textureName = "\(type)_\(SpriteDirection.SIDE.rawValue)"
        animations[.SIDE] = [SKTexture(imageNamed: textureName)]
        
        textureName = "\(type)_\(SpriteDirection.BACK.rawValue)"
        animations[.BACK] = [SKTexture(imageNamed: textureName)]
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
        if let texture = texture
        {
            self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size()*CGFloat(0.8))
        }
        else
        {
            self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
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
        self.physicsBody?.velocity = playerSpeed
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
        self.rotation = angle
        
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
    
    func checkCollision() {
        
    }
}


extension Player
{
    func updateDirection()
    {
        if animations.count > 0
        {
            var angle = self.rotation.degrees
            angle = angle > 0 ? angle : (360.0 + angle)
            let angle_range : CGFloat = 40.0
            
            if angle.inBetween(0, angle_range) || angle.inBetween(360-angle_range, 360)
            {
                if let animate = self.animations[.SIDE]
                {
                    self.run(SKAction.animate(with: animate, timePerFrame: 0.4), withKey: "animation")
                    self.xScale = abs(xScale)
                }
            }
            else if angle.inBetween(angle_range, 180-angle_range)
            {
                if let animate = self.animations[.BACK]
                {
                    self.run(SKAction.animate(with: animate, timePerFrame: 0.4), withKey: "animation")
                    if angle.inBetween(angle_range, (180-angle_range)/2.0)
                    {
                        self.xScale = abs(xScale)
                    }
                    else
                    {
                        self.xScale = -abs(xScale)
                    }
                }
            }
            else if angle.inBetween(180-angle_range, 180+(2.0 * angle_range))
            {
                if let animate = self.animations[.SIDE]
                {
                    self.run(SKAction.animate(with: animate, timePerFrame: 0.4), withKey: "animation")
                    self.xScale = -abs(xScale)
                }
            }
            else if angle.inBetween(180+(2.0 * angle_range), 360-angle_range)
            {
                if let animate = self.animations[.FRONT]
                {
                    self.run(SKAction.animate(with: animate, timePerFrame: 0.4), withKey: "animation")
                }
            }
        }
    }
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
        switch type {
        case .TELEPORT:
            lastTeleporter = nil
        default:
            return
        }
    }
    
    func performCollision(type : CollisionType, node: SKNode? = nil)
    {
        //print(type)
        switch type {
        case .TRAIL:
            if !destroyed
            {
                if let node = node
                {
                    if node.name == self.alias
                    {
                        destroyPlayer(reason: .HIT_MYSELF)
                        MultiplayerNetworking.shared.sendPlayerDestroyed(name: self.alias)
                    }
                    else
                    {
                        destroyPlayer(reason: .HIT_OTHER_PLAYER)
                        MultiplayerNetworking.shared.sendPlayerDestroyed(name: self.alias)
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
                    self.animationLastPoint = pos
                    setPosition(pos)
                }
            }
        case .WALL_DESTROY:
//            print("Destroy:", alias)
            destroyPlayer(reason: .HIT_WALL)
            MultiplayerNetworking.shared.sendPlayerDestroyed(name: self.alias)
        case .WALL:
            if !collide {
                collide = true
//                let newAngle = (90-self.rotation.degrees) + 90
//                print(self.rotation.degrees, newAngle.degrees)
//                setRotation(to: newAngle.radians)
//                setSpeed()
//                //invertSpeed()
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
//    func getLastPathPoint(scale: CGFloat = 0) -> CGPoint{
//        let normalizedSpeed = self.playerSpeed.normalized()
//        let width = scale != 0 ? scale : 1
//
//        let offset = normalizedSpeed * (self.size.height + 20) / 2 * width
//
//        return CGPoint(x: self.position.x - offset.dx, y: self.position.y - offset.dy)
//    }
//
//    func showPath() {
//        let smoothPath = SKAction.run({
//            let path = CGMutablePath()
//            //            if self.animationLastPoint == nil {
//            //                self.animationLastPoint = self.getLastPathPoint()
//            //            }
//            self.animationLastPoint = self.getLastPathPoint()
//
//            path.move(to: self.animationLastPoint!)
//            path.addLine(to: self.getLastPathPoint(scale: 2))
//
//            let node = SKShapeNode(path: path)
//            node.strokeColor = #colorLiteral(red: 0.6987038255, green: 0.9717952609, blue: 0.4537590742, alpha: 1)
//            node.lineWidth = 20
//            self.animationPoints.append(node)
//            self.scene?.addChild(node)
//            let fadeOut = SKAction.fadeOut(withDuration: 4)
//            let remove = SKAction.removeFromParent()
//            node.run(SKAction.sequence([fadeOut, remove]))
//            //            self.animationLastPoint = self.getLastPathPoint()
//
//            node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
//            node.physicsBody?.isDynamic = false
//            node.name = "Path"
//        })
//
//        self.run(SKAction.repeatForever(SKAction.sequence([smoothPath, SKAction.wait(forDuration: 0.1)])))
//    }
    
    func showPath() {
        let smoothPath = SKAction.run({
            if self.lastPosition.distance(to: self.position) > 30
            {
                self.lastPosition = self.position
                let path = CGMutablePath()
                if self.animationLastPoint == nil {
                    self.animationLastPoint = CGPoint(x: self.position.x, y: self.position.y)
                }
                path.move(to: self.animationLastPoint!)
                path.addLine(to: self.position)

                let node = SKShapeNode(path: path)
                node.strokeColor = .black //#colorLiteral(red: 0.6987038255, green: 0.9717952609, blue: 0.4537590742, alpha: 1)
                node.lineWidth = 40
                node.zPosition = self.zPosition - 1

                self.animationPoints.append(node)
                self.scene?.addChild(node)
                let wait = SKAction.wait(forDuration: 5)
                let fadeOut = SKAction.fadeOut(withDuration: 1)
                let remove = SKAction.removeFromParent()
                
                let waitPhysics = SKAction.wait(forDuration: 1)
                let trailPhysics = SKAction.run {
                    node.physicsBody = SKPhysicsBody(edgeLoopFrom: path)
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
                
                
//                node.physicsBody = SKPhysicsBody(edgeLoopFrom: path) //SKPhysicsBody(polygonFrom: path) //SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
//                node.physicsBody?.isDynamic = true
//                node.physicsBody?.friction = 0
//                node.physicsBody?.restitution = 0
//                node.physicsBody?.categoryBitMask = PhysicsCategory.TRAIL.rawValue
//                node.physicsBody?.collisionBitMask = 0
//                node.physicsBody?.contactTestBitMask = PhysicsCategory.PLAYER.rawValue
//                node.name = self.alias
//
//                node.physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
//                node.position = self.animationLastPoint!
//                node.physicsBody?.isDynamic = false
//                node.physicsBody?.categoryBitMask = PhysicsCategory.TRAIL.rawValue
//                node.physicsBody?.collisionBitMask = 0
//                node.physicsBody?.contactTestBitMask = PhysicsCategory.PLAYER.rawValue
//                node.name = self.alias
                
                self.animationLastPoint = self.position
//                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
//                    node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
                
//                    node.physicsBody?.isDynamic = true
//                    node.physicsBody?.categoryBitMask = PhysicsCategory.TRAIL.rawValue
//                    node.physicsBody?.collisionBitMask = 0
//                    node.physicsBody?.contactTestBitMask = PhysicsCategory.PLAYER.rawValue
//                    node.name = self.alias
//                    print(node)
//                })
            }
            
        })

        self.run(SKAction.repeatForever(SKAction.sequence([smoothPath, SKAction.wait(forDuration: 0.03)])))
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
