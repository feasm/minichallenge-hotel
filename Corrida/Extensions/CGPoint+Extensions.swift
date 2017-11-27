//
//  CGPoint+Extensions.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 24/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

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
    
    func distance(to a: CGPoint) -> CGFloat {
        let xDist = self.x - a.x
        let yDist = self.y - a.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    func angle(_ from: CGPoint, degrees: Bool = true) -> CGFloat
    {
        let radians = atan2(from.y-self.y, from.x-self.x)
        if degrees
        {
            var degreeAngle = radians * (180.0/CGFloat.pi)
            degreeAngle = degreeAngle > 0 ? degreeAngle : (360.0 + degreeAngle)
            return degreeAngle
        }
        return radians
    }
    
    static func vectorDirection(length: CGFloat, direction: CGFloat, degrees : Bool = true) -> CGPoint
    {
        var angle = direction
        if degrees
        {
            angle = direction.radians
        }
        
        return CGPoint(x: cos(angle)*length, y: sin(angle)*length)
    }
    
    func positionDirection(length: CGFloat, direction: CGFloat, degrees : Bool = true) -> CGPoint
    {
        let vector = CGPoint.vectorDirection(length: length, direction: direction, degrees: degrees)
        return self + vector
    }
    
}



extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
