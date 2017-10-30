//
//  Action.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 24/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit
import SpriteKit

enum ActionTypes : String, Codable
{
    case NONE = "a_none"
    case CLEAN_FLOOR = "a_clean_floor"
    case CLEAN_ROOM = "a_clean_room"
    case WALK_TO = "a_walk"
    case USE_TELEPORTER = "a_teleporter"
    case CHANGE_FLOOR = "a_change_floor"
}

class Action {
    var type : ActionTypes!
    var actions : [SKAction] = []
    var current : SKAction?
    init(type: ActionTypes, actions : [SKAction]) {
        self.actions = actions
        self.type = type
    }
}
