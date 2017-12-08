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
    
    static let pColorDog : UIColor = UIColor(r: 85, g: 251, b: 255)
    static let pColorBird : UIColor = UIColor(r: 232, g: 119, b: 75)
    static let pColorGoo : UIColor = UIColor(r: 142, g: 198, b: 62)
    static let pColorDemon : UIColor = UIColor(r: 255, g: 208, b: 10)
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat)
    {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

