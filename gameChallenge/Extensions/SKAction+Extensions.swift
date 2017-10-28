//
//  SKAction+Extensions.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 24/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit
import SpriteKit

extension SKAction
{
    open class func walkTo(from: CGPoint, to: CGPoint, speed: CGFloat) -> SKAction
    {
        let duration = TimeInterval(abs(from.x - to.x)/(speed*100))
        let goTo = CGPoint(x: to.x, y: from.y)
        return SKAction.move(to: goTo, duration: duration)
    }
}
