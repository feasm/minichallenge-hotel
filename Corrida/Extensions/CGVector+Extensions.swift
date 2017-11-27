//
//  CGVector.swift
//  Corrida
//
//  Created by Felipe Melo on 11/23/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import UIKit

extension CGVector {
    static func + (left: CGVector, right: CGFloat) -> CGVector {
        return CGVector(dx: left.dx + right, dy: left.dy + right)
    }
//
//    func - (left: CGVector, right: CGPoint) -> CGPoint {
//        return CGPoint(x: left.dx - right.x, y: left.y - right.y)
//    }
//
    static func * (vector: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
    }
    
    static func / (vector: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
    }
    
    
    func length() -> CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    
    func normalized() -> CGVector {
        return self / length()
    }
    
    func invert() -> CGVector
    {
        return CGVector(dx: self.dy, dy: -self.dy)
    }
}
