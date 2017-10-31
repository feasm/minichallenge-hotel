//
//  BaseNode.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 24/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit
import SpriteKit

protocol BaseNodeDelegate
{
    func actionEnded(action: Action)
}

class BaseNode : SKSpriteNode
{
    var gameScene : GameScene?
    var runningAction : Action?
    var delegate : BaseNodeDelegate?
    let walkHeightRandom : UInt32 = 20
    var walkHeight: CGFloat!
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        let random = Int(arc4random_uniform(walkHeightRandom*2))
        let r = random - Int(walkHeightRandom)
        walkHeight = 180 + CGFloat(r)
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.zPosition = 15
        setupPhysicsBody(size : size)
    }
    
    func setupPhysicsBody(size : CGSize)
    {
        let center = CGPoint(x: 0, y: size.height/2)
        self.physicsBody = SKPhysicsBody(rectangleOf: size, center: center)
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
    }
    
    func setPositionByFloor(_ position: CGPoint?, floor floorID: Int)
    {
        if position == nil
        {
            if let floor = GameModel.shared.hotel.loadFloor(floorID: floorID)
            {
                let teleporter = floor.getTeleporterPosition()
                self.position = CGPoint(x: teleporter.x, y: teleporter.y + walkHeight)
            }
        }
        else
        {
            if let floor = GameModel.shared.hotel.loadFloor(floorID: floorID)
            {
                let teleporter = floor.getTeleporterPosition()
                self.position = CGPoint(x: (position?.x)!, y: teleporter.y + walkHeight)
            }
        }
    }
    
    func addNode(to scene: SKScene, position: CGPoint = .zero)
    {
        if scene.isKind(of: GameScene.self)
        {
            gameScene = scene as? GameScene
        }
        
        scene.addChild(self)
        if position != .zero
        {
            self.position = position
        }
        self.position.y = walkHeight
    }
    
    func applyAction(_ action: Action)
    {
        runningAction = action
        self.run(SKAction.group(action.actions)) {
            self.delegate?.actionEnded(action: action)
            self.runningAction = nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
