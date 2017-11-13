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
    
    init(position: CGPoint, texture: SKTexture)
    {
        super.init()
        self.sprite = SKSpriteNode(texture: texture, color: .clear, size: texture.size())
        self.sprite.position = position
    }
    
    convenience init(tile: CGPoint, direction: String) {
        let tilePosition = BuildManager.tilePosition(tile: tile)
        var position = CGPoint()
        let texture : SKTexture = SKTexture(imageNamed: BuildingType.SIMPLE_ROOM.rawValue)
        
        switch direction {
        case "rugBottom":
            position = tilePosition + CGPoint(x: 0, y: -(texture.size().height/2.0))
        case "rugTop":
            position = tilePosition + CGPoint(x: 0, y: (texture.size().height/2.0)+(BuildManager.TILE_SIZE/2))
        case "rugLeft":
            position = tilePosition + CGPoint(x: -1.5*BuildManager.TILE_SIZE, y: 0)
        case "rugRight":
            position = tilePosition + CGPoint(x: 1.5*BuildManager.TILE_SIZE, y: 0)
        default:
            position = tilePosition + CGPoint(x: 0, y: -1.5*BuildManager.TILE_SIZE)
        }
        
        self.init(position: position, texture: texture)
        
        self.sprite.zPosition = tile.y
        let collisionSprite = SKSpriteNode(color: .white, size: CGSize(width: texture.size().width, height: texture.size().height*0.8))
        collisionSprite.name = "collisionMask"
        collisionSprite.alpha = 0
        collisionSprite.physicsBody = SKPhysicsBody(rectangleOf: collisionSprite.size, center: CGPoint(x: 0, y: -texture.size().height*0.1))
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
