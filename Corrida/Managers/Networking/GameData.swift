//
//  GameData.swift
//  topDownHotel
//
//  Created by Felipe Melo on 11/9/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

enum MessageType: String, Codable {
    case CHARACTER_CHANGED = "character_changed"
    case GAME_BEGIN = "game_begin"
    case PLAYER_READY = "player_ready"
    case PLAYER_MESSAGE = "player_message"
    case CHANGE_MAP = "change_map"
    case START_MAP = "start_map"
    case PLAYER_MOVEMENT = "player_movement"
    case PLAYER_DESTROYED = "player_destroyed"
}

struct GameData: Codable {
    let messageType: MessageType
    
    var playerNames: [String]?
    
    var playerNumber: Int?
    var character: CharactersEnum?
    var readyStatus: PlayerStatusEnum?
    
    var currentMap: Int?
    
    var name: String?
    var position: CGPoint?
    var rotation: CGFloat?
    
    init(messageType: MessageType) {
        self.messageType = messageType
    }
}

// MARK: Game Begin
extension GameData {
    init(messageType: MessageType, _ playerNames: [String]) {
        self.messageType = messageType
        self.playerNames = playerNames
    }
}

// MARK: Character Selection
extension GameData {
    init(messageType: MessageType, _ playerNumber: Int, _ character: CharactersEnum) {
        self.messageType = messageType
        self.playerNumber = playerNumber
        self.character = character
    }
    
    init(messageType: MessageType, _ playerNumber: Int, _ readyStatus: PlayerStatusEnum) {
        self.messageType = messageType
        self.playerNumber = playerNumber
        self.readyStatus = readyStatus
    }
}

// MARK: Map Selection
extension GameData {
    init(messageType: MessageType, _ currentMap: Int) {
        self.messageType = messageType
        self.currentMap = currentMap
    }
}

// MARK: Player Data
extension GameData {
    init(messageType: MessageType, name: String, position: CGPoint, rotation: CGFloat) {
        self.messageType = messageType
        self.name = name
        self.position = position
        self.rotation = rotation
    }
    
    init(messageType: MessageType, name: String) {
        self.messageType = messageType
        self.name = name
    }
}

