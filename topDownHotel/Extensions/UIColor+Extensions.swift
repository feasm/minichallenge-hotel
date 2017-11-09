//
//  UIColor+Extensions.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 24/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit
import SpriteKit

extension UIColor
{
    static let pYellow : UIColor = UIColor(red: 254/255, green: 194/255, blue: 45/255, alpha: 1)
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat)
    {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

