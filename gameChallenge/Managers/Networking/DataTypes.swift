//
//  Utils.swift
//  gameChallenge
//
//  Created by Felipe Melo on 10/30/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit

enum MessageType: String, Codable {
    case PLAYER_MESSAGE = "player"
    
    case SPAWN_GUEST = "spawn"
    case GUEST_MESSAGE = "guest"
    
    case REMOVE_DIRTY = "remove_dirty"
}

struct GameData: Codable {
    let messageType: MessageType
    let name: String?
    let target: Target?
    let state: PlayerState?
    let guestIndex: Int?
    let centerPoint: CGPoint?
}
