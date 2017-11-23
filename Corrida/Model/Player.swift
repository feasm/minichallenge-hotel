//
//  Player.swift
//  Corrida
//
//  Created by Felipe Melo on 11/22/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    static let CONSTANT_SPEED: CGFloat = 400.0
    static let ROTATION_SPEED: Float = 0.1
    
    var alias: String!
    var playerSpeed: CGVector = CGVector(dx: 0, dy: Player.CONSTANT_SPEED)
    var rotation: CGFloat = 0
    
    var animationLastPoint: CGPoint?
    var animationPoints = [SKShapeNode]()
    
    func setup(alias: String) {
        self.alias = alias
        
        self.showPath()
        self.setPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update(direction: PlayerDirection) {
        self.setDirection(direction)
        self.checkCollision()
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
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        self.physicsBody!.contactTestBitMask = self.physicsBody!.collisionBitMask
        
        self.setSpeed()
    }
    
    func setSpeed() {
        self.physicsBody?.velocity = playerSpeed
    }
    
    func rotateByAngle(_ angle: Float) {
        let ca = cosf(angle)
        let sa = sinf(angle)
        
        self.playerSpeed = CGVector(
            dx: CGFloat(ca) * self.playerSpeed.dx - CGFloat(sa) * self.playerSpeed.dy,
            dy: CGFloat(sa) * self.playerSpeed.dx + CGFloat(ca) * self.playerSpeed.dy
        )
        
        let angle = atan2(self.playerSpeed.dy, self.playerSpeed.dx)
        self.zRotation = angle
    }
    
    func checkCollision() {
        
    }
}

// MARK: Player Collisions
extension Player {
    
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
