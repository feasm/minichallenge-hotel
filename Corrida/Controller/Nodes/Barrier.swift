//
//  Barrier.swift
//  Corrida
//
//  Created by Adonay Puszczynski on 25/11/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import SpriteKit

class Barrier: SKSpriteNode {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        zPosition = NodesZPosition.ASSETS.rawValue
    }

    func setupPhysics()
    {
        if let texture = texture
        {
//            print(self.size.height, (texture.size().height)!)
            let body = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width*0.7, height: self.size.height*0.6), center: CGPoint(x: 0, y: -50)*(self.size.height/texture.size().height))
            body.affectedByGravity = false
            body.allowsRotation = false
            body.pinned = true
            body.categoryBitMask = PhysicsCategory.BARRIER.rawValue
            body.collisionBitMask = 0
            body.contactTestBitMask = PhysicsCategory.PLAYER.rawValue
            self.physicsBody = body
        }
        else
        {
            let body = SKPhysicsBody(rectangleOf: self.size)
            body.affectedByGravity = false
            body.allowsRotation = false
            body.pinned = true
            body.categoryBitMask = PhysicsCategory.BARRIER.rawValue
            body.collisionBitMask = 0
            body.contactTestBitMask = PhysicsCategory.PLAYER.rawValue
            self.physicsBody = body
        }
        
//        if let texture = texture
//        {
//            //let body = SKPhysicsBody(texture: texture, size: self.size)
//            body.affectedByGravity = false
//            body.allowsRotation = false
//            body.pinned = true
//            body.categoryBitMask = PhysicsCategory.BARRIER.rawValue
//            body.collisionBitMask = 0
//            body.contactTestBitMask  = PhysicsCategory.PLAYER.rawValue
//            self.physicsBody = body
//        }
//        else
//        {
//            let body = SKPhysicsBody(rectangleOf: self.size)
//            body.affectedByGravity = false
//            body.allowsRotation = false
//            body.pinned = true
//            body.categoryBitMask = PhysicsCategory.BARRIER.rawValue
//            body.collisionBitMask = 0
//           // body.collisionBitMask = PhysicsCategory.PLAYER.rawValue
//            body.contactTestBitMask = PhysicsCategory.PLAYER.rawValue
//            self.physicsBody = body
//        }
    }
}
