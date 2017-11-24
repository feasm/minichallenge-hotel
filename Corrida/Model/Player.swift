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
    static let CONSTANT_SPEED: CGFloat = 400.0
    static let ROTATION_SPEED: Float = 0.05
    
    var alias: String!
    var playerSpeed: CGVector = CGVector(dx: 0, dy: Player.CONSTANT_SPEED)
    var rotation: CGFloat = 0
    
    var animationLastPoint: CGPoint?
    var animationPoints = [SKShapeNode]()
    
    var animations : [SpriteDirection : [SKTexture]] = [:]
    
    func setup(alias: String) {
        self.alias = alias
        
        self.showPath()
        self.setPhysics()
    }
    
    init(type: String) {
        var textureName = "\(type)_\(SpriteDirection.FRONT.rawValue)"
        animations[.FRONT] = [SKTexture(imageNamed: textureName)]
        
        textureName = "\(type)_\(SpriteDirection.SIDE.rawValue)"
        animations[.SIDE] = [SKTexture(imageNamed: textureName)]
        
        textureName = "\(type)_\(SpriteDirection.BACK.rawValue)"
        animations[.BACK] = [SKTexture(imageNamed: textureName)]
        
        super.init(texture: nil, color: .white, size: CGSize(width: 300, height: 300))
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
        //print(zRotation)
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
}

// MARK: Player Physics
extension Player {
    func setPhysics() {
        //self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        self.physicsBody!.contactTestBitMask = self.physicsBody!.collisionBitMask
        
        self.setSpeed()
    }
    
    
    
    func setSpeed() {
        self.physicsBody?.velocity = playerSpeed
    }
    
    func setRotation(to angle: CGFloat)
    {
        
    }
    
    func rotateByAngle(_ angle: Float) {
    
        setSpeed()
        
        let ca = cosf(angle)
        let sa = sinf(angle)
        
        self.playerSpeed = CGVector(
            dx: CGFloat(ca) * self.playerSpeed.dx - CGFloat(sa) * self.playerSpeed.dy,
            dy: CGFloat(sa) * self.playerSpeed.dx + CGFloat(ca) * self.playerSpeed.dy
        )
        
        let angle = atan2(self.playerSpeed.dy, self.playerSpeed.dx)
        //self.zRotation = angle
        self.rotation = angle
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
}


// MARK: Player Collisions
extension Player {
    func performCollision(type : CollisionType)
    {
        switch type {
        case .WALL:
            let newAngle = 180-self.rotation.degrees360
            print(self.rotation.degrees360, newAngle)
            //rotateByAngle(Float(newAngle.radians))
            setSpeed()
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
            let path = CGMutablePath()
            if self.animationLastPoint == nil {
                self.animationLastPoint = CGPoint(x: self.position.x, y: self.position.y)
            }
            path.move(to: self.animationLastPoint!)
            path.addLine(to: self.position)

            let node = SKShapeNode(path: path)
            node.strokeColor = #colorLiteral(red: 0.6987038255, green: 0.9717952609, blue: 0.4537590742, alpha: 1)
            node.lineWidth = 20

            self.animationPoints.append(node)
            self.scene?.addChild(node)
            let wait = SKAction.wait(forDuration: 5)
            let fadeOut = SKAction.fadeOut(withDuration: 1)
            let remove = SKAction.removeFromParent()
            node.run(SKAction.sequence([wait, fadeOut, remove]))
            self.animationLastPoint = self.position
            
            node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
            node.physicsBody?.isDynamic = false
            node.name = "Path"
            
//            Timer.scheduledTimer(timeInterval: 1, target: node, selector: #selector(self.setPhysicsOnPath(sender:)), userInfo: nil, repeats: false)
        })

        self.run(SKAction.repeatForever(SKAction.sequence([smoothPath, SKAction.wait(forDuration: 0.03)])))
    }
    
    @objc func setPhysicsOnPath(sender: Any) {
        let node = sender as! SKNode
        
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
        node.physicsBody?.isDynamic = false
        node.name = "Path"
    }
}
