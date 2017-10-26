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
    }
    
    func addNode(to scene: SKScene, position: CGPoint = .zero)
    {
        scene.addChild(self)
        if position != .zero
        {
            self.position = position
        }
        self.position.y = walkHeight
    }
    
    func applyAction(_ action: Action)
    {
        print("Chegou em applyAction")
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
