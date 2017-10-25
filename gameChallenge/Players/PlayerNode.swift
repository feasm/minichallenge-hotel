//
//  PlayerNode.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 24/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit





protocol PlayerNodeDelegate
{
    func actionEnded(action: SKAction)
}

class PlayerNode : SKSpriteNode
{
    var runningAction : SKAction?
    var delegate : PlayerNodeDelegate?
    let walkHeightRandom : UInt32 = 20
    var walkHeight: CGFloat!
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        let random = Int(arc4random_uniform(walkHeightRandom*2))
        let r = random - Int(walkHeightRandom)
        walkHeight = 180 + CGFloat(r)
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
    }
    
    func add(to scene: SKScene)
    {
        scene.addChild(self)
        self.position.y = walkHeight
    }
    
    func applyAction(_ action: SKAction)
    {
        runningAction = action
        if let runAction = runningAction
        {
            self.run(runAction)
            {
                self.delegate?.actionEnded(action: runAction)
                self.runningAction = nil
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
