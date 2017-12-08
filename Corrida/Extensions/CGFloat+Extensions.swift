//
//  CGFloat+Extensions.swift
//  Corrida
//
//  Created by Adonay Puszczynski on 23/11/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import UIKit

extension CGFloat
{
    var degrees: CGFloat {
        return self * CGFloat(180.0 / Double.pi)
    }
    
    var degrees360: CGFloat {
        let angle = self * CGFloat(180.0 / Double.pi)
        return angle > 0 ? angle : (360.0 + angle)
        
    }
    
    var radians: CGFloat {
        return self * CGFloat(Double.pi / 180.0)
    }
    
    func inBetween(_ value: CGFloat, _ value2 : CGFloat) -> Bool
    {
        return (self >= value && self <= value2)
    }
}
