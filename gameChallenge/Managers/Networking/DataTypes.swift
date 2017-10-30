//
//  Utils.swift
//  gameChallenge
//
//  Created by Felipe Melo on 10/30/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit

enum MessageType {
    case PLAYER_MESSAGE
    case GUEST_MESSAGE
}

struct GameData: Codable {
//    let messageType: MessageType
    let name: String
    let target: Target
    let state: PlayerState
}
