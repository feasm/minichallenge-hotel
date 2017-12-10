//
//  Effect.swift
//  Corrida
//
//  Created by Adonay Puszczynski on 06/12/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import SpriteKit

enum EffectType: String
{
    case SPEED = "e_speed"
    case INVULNERABILITY = "e_invul"
    case JUMP = "e_jump"
    case EXTRA_LIFE = "e_extralife"
    case NONE = "e_none"
}

class Effect : SKSpriteNode
{
    private(set) var type : EffectType!
    var lastScene : SKScene!
    var active : Bool = true
    
    let MIN_TIME : Int = 15
    let MAX_TIME : Int = 30
    
    var animationTextures : [SKTexture] = []
    
    
    
    init(type : EffectType, scene: SKScene) {
        let texture = SKTexture(imageNamed: type.rawValue)
        super.init(texture: texture, color: .white, size: texture.size())
        
        self.type = type
        loadAnimations()
        
        self.add(to: scene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAnimations()
    {
        animationTextures.removeAll()
        animationTextures.append(SKTexture(imageNamed: type.rawValue))
        for i in 1...2
        {
            let texture = SKTexture(imageNamed: "\(type.rawValue)-\(i)")
            animationTextures.append(texture)
        }
    }
    
    func add(to scene: SKScene)
    {
        self.lastScene = scene
        scene.addChild(self)
        
        self.position = randomPosition()
        self.zPosition = NodesZPosition.ASSETS.rawValue
        self.alpha = 1
        self.setScale(1)
        
        let actions = SKAction.sequence([SKAction.scale(to: 0.85, duration: 1), SKAction.scale(to: 1, duration: 1)])
        let animate = SKAction.animate(with: animationTextures, timePerFrame: 0.25)
        
//        let actions = SKAction.sequence([SKAction.moveBy(x: 0, y: 100, duration: 0.5), SKAction.moveBy(x: 0, y: -50, duration: 0.5)])
        self.run(SKAction.repeatForever(actions))
        self.run(SKAction.repeatForever(animate), withKey: "animate")
        
        setupPhysics()
    }
    
    func get() -> EffectType
    {
        if active
        {
            self.active = false
            if scene != nil
            {
                self.removeAllActions()
                self.physicsBody = nil
                self.run(SKAction.group([SKAction.fadeAlpha(to: 0, duration: 0.3), SKAction.scale(to: 0.1, duration: 0.3)]))
                {
                    self.removeFromParent()
                }
                let random = arc4random_uniform(UInt32(MAX_TIME-MIN_TIME))
                let randomTime = TimeInterval(Int(random) + MIN_TIME)
                Timer.scheduledTimer(withTimeInterval: randomTime, repeats: false, block: { (_) in
                    self.add(to: self.lastScene)
                    self.active = true
                })
            }
            return type
        }
        return .NONE
    }
    
    func randomPosition() -> CGPoint
    {
        var randomPosition : CGPoint = .zero
        let proportion : CGFloat = 0.9
        if let scene = scene as? GameScene
        {
            let size = scene.background.size
            let randomX = arc4random_uniform(UInt32(size.width * proportion))
            let randomY = arc4random_uniform(UInt32(size.height * proportion))
            randomPosition = CGPoint(x: CGFloat(randomX)-(proportion*(size.width/2.0)), y: CGFloat(randomY)-(proportion*(size.height/2.0)))
        }
        return randomPosition
    }
    
    func setupPhysics()
    {
        if let texture = texture
        {
            let body = SKPhysicsBody(texture: texture, size: self.size)
            body.affectedByGravity = false
            body.allowsRotation = false
            body.pinned = true
            body.categoryBitMask = PhysicsCategory.BOOST.rawValue
            body.collisionBitMask = 0
            body.contactTestBitMask  = PhysicsCategory.PLAYER.rawValue
            self.physicsBody = body
        }
        else
        {
            let body = SKPhysicsBody(rectangleOf: self.size)
            body.affectedByGravity = false
            body.allowsRotation = false
            body.pinned = true
            body.categoryBitMask = PhysicsCategory.BOOST.rawValue
            body.collisionBitMask = 0
            body.contactTestBitMask  = PhysicsCategory.PLAYER.rawValue
            self.physicsBody = body
        }
    }
}
