//
//  GameData.swift
//  topDownHotel
//
//  Created by Felipe Melo on 11/9/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import Foundation

enum MessageType: String, Codable {
    case PLAYER_MESSAGE = "player_message"
    case GUEST_MESSAGE = "guest_message"
    case ACTION_MESSAGE = "action_message"
    case SPAWN_GUEST = "spawn_guest"
}

class GameData: Codable {
    let messageType: MessageType
    
    init(messageType: MessageType) {
        self.messageType = messageType
    }
}

class CommonData: GameData {
    override init(messageType: MessageType) {
        super.init(messageType: messageType)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}



class PlayerData: CommonData {
    override init(messageType: MessageType) {
        super.init(messageType: .PLAYER_MESSAGE)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class GuestData: CommonData {
    override init(messageType: MessageType) {
        super.init(messageType: .GUEST_MESSAGE)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
