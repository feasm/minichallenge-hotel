//
//  VisualComponent.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 07/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit
import SpriteKit

class VisualComponent : GKComponent
{
    private(set) var sprite: SKSpriteNode
    
    private var isMoving = false
    private var moveSpeed = 30
    
    init(position: CGPoint, color: SKColor) {
        let size = CGSize(width: 128, height: 128)
        
        sprite = SKSpriteNode(color: color, size: size)
        sprite.position = position
        sprite.physicsBody = SKPhysicsBody(rectangleOf: size, center: .zero)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.friction = 0
        
        super.init()
    }
    
    func runActions(actions: [SKAction])
    {
        sprite.run(SKAction.group(actions))
        {
            
        }
        
        //sprite.run(SKAction.reach(to: target, rootNode: , velocity: CGFloat(3.0)))
        //sprite.position = sprite.position + (position * CGFloat(moveSpeed))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
