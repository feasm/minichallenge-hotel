//
//  Utils.swift
//  memoryGame
//
//  Created by Adonay Puszczynski on 28/09/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit
import UIKit

func + (left: CGPoint, right: CGPoint) -> CGPoint
{
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint
{
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (left: CGPoint, scalar: CGFloat) -> CGPoint
{
    return CGPoint(x: left.x * scalar, y: left.y * scalar)
}

func / (left: CGPoint, scalar: CGFloat) -> CGPoint
{
    return CGPoint(x: left.x / scalar, y: left.y / scalar)
}


extension SKScene
{
    func middlePoint() -> CGPoint
    {
        return CGPoint(x: self.size.width/2, y: self.size.height/2)
    }
}

extension SKColor
{
    static let pYellow : UIColor = UIColor(red: 254/255, green: 194/255, blue: 45/255, alpha: 1)
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat)
    {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}


extension CGPoint
{
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint
    {
        return self / length()
    }
    
    func rotate(angle: CGFloat) -> CGPoint
    {
        return CGPoint(x: x*cos(angle) - y * sin(angle), y: x*sin(angle) + y*cos(angle))
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
