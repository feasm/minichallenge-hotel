//
//  PhysicsCategory.swift
//  Corrida
//
//  Created by Adonay Puszczynski on 25/11/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import UIKit

enum PhysicsCategory : UInt32
{
    typealias RawValue = UInt32
    case WALL = 1
    case BARRIER = 2
    case PLAYER = 3
    case TELEPORT = 4
    case TRAIL = 5
    case BOOST = 6
}
