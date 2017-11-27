//
//  Teleporter.swift
//  Corrida
//
//  Created by Adonay Puszczynski on 25/11/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import SpriteKit

class Teleporter: SKSpriteNode {
    
    var teleporter : Int!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let data = userData
        {
            if let teleporter = data["id"] as? Int
            {
                self.teleporter = teleporter
            }
        }
        
        zPosition = NodesZPosition.ASSETS.rawValue
    }
    
    func setupPhysics()
    {
        let sizeScale : CGFloat = 0.4
        if let texture = texture
        {
            let body = SKPhysicsBody(texture: texture, size: self.size*sizeScale)
            body.affectedByGravity = false
            body.allowsRotation = false
            body.pinned = true
            body.categoryBitMask = PhysicsCategory.TELEPORT.rawValue
            body.collisionBitMask = 0
            body.contactTestBitMask  = PhysicsCategory.PLAYER.rawValue
            self.physicsBody = body
        }
        else
        {
            let body = SKPhysicsBody(rectangleOf: self.size*sizeScale)
            body.affectedByGravity = false
            body.allowsRotation = false
            body.pinned = true
            body.categoryBitMask = PhysicsCategory.TELEPORT.rawValue
            body.collisionBitMask = 0
            body.contactTestBitMask = PhysicsCategory.PLAYER.rawValue
            self.physicsBody = body
        }
    }
}
