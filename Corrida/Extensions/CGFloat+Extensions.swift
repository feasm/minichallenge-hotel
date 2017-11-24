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

    var radians: CGFloat {
        return self * CGFloat(Double.pi / 180.0)
    }

}
