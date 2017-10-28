//
//  Utils.swift
//  memoryGame
//
//  Created by Adonay Puszczynski on 28/09/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit
import UIKit

extension SKScene
{
    func middlePoint() -> CGPoint
    {
        return CGPoint(x: self.size.width/2, y: self.size.height/2)
    }
}

extension Array {
    var shuffled: Array {
        var array = self
        indices.dropLast().forEach {
            guard case let index = Int(arc4random_uniform(UInt32(count - $0))) + $0, index != $0 else { return }
            array.swapAt($0, index)
        }
        return array
    }
    var chooseOne: Element {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
    
}
