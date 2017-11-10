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
    private(set) var sprite: SKSpriteNode!
    
    private var isMoving = false
    private var moveSpeed = 30
    
    init(position: CGPoint, color: SKColor, size: CGSize) {
        super.init()
        self.sprite = SKSpriteNode(color: color, size: size)
        self.sprite.position = position
    }
    
    convenience init(tile: CGPoint, direction: String) {
        let tilePosition = BuildManager.tilePosition(tile: tile)
        var position = CGPoint()
        var size = CGSize()
        switch direction {
        case "rugBottom":
            position = tilePosition + CGPoint(x: 0, y: -1.5*BuildManager.TILE_SIZE)
            size = CGSize(width: 5*BuildManager.TILE_SIZE, height: 2*BuildManager.TILE_SIZE)
        case "rugTop":
            position = tilePosition + CGPoint(x: 0, y: 1.5*BuildManager.TILE_SIZE)
            size = CGSize(width: 5*BuildManager.TILE_SIZE, height: 2*BuildManager.TILE_SIZE)
        case "rugLeft":
            position = tilePosition + CGPoint(x: -1.5*BuildManager.TILE_SIZE, y: 0)
            size = CGSize(width: 2*BuildManager.TILE_SIZE, height: 5*BuildManager.TILE_SIZE)
        case "rugRight":
            position = tilePosition + CGPoint(x: 1.5*BuildManager.TILE_SIZE, y: 0)
            size = CGSize(width: 2*BuildManager.TILE_SIZE, height: 5*BuildManager.TILE_SIZE)
        default:
            position = tilePosition + CGPoint(x: 0, y: -1.5*BuildManager.TILE_SIZE)
            size = CGSize(width: 5*BuildManager.TILE_SIZE, height: 2*BuildManager.TILE_SIZE)
        }
        self.init(position: position, color: .yellow, size: size)
        self.sprite.zPosition = tile.y
        let collisionSprite = SKSpriteNode(color: .white, size: size)
        collisionSprite.name = "collisionMask"
        collisionSprite.alpha = 0
        collisionSprite.physicsBody = SKPhysicsBody(rectangleOf: collisionSprite.size, center: .zero)
        collisionSprite.physicsBody?.affectedByGravity = false
        collisionSprite.physicsBody?.allowsRotation = false
        collisionSprite.physicsBody?.friction = 0
        collisionSprite.physicsBody?.isDynamic = false
        sprite.addChild(collisionSprite)
    }
    
    convenience init(position: CGPoint, color: SKColor, physics: Bool) {
        let size = CGSize(width: 96, height: 96)
        self.init(position: position, color: color, size: size)
        if physics
        {
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size, center: .zero)
            sprite.physicsBody?.affectedByGravity = false
            sprite.physicsBody?.allowsRotation = false
            sprite.physicsBody?.friction = 0
            sprite.physicsBody?.usesPreciseCollisionDetection = true
        }
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
