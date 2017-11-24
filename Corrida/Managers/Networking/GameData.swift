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
//    init(messageType: MessageType, name: String, target: Target?, position: CGPoint) {
//        self.messageType = messageType
//
//        self.name = name
//        self.target = target
//        self.position = position
//    }
}

//class GameData {
//    let messageType: MessageType
//
//    init(messageType: MessageType) {
//        self.messageType = messageType
//    }
//
//    required init?(coder aDecoder: NSCoder)
//    {
//        self.messageType = aDecoder.decodeObject(forKey: "messageType") as! MessageType
//    }
//
//    func encode(with aCoder: NSCoder)
//    {
//        aCoder.encode(self.messageType, forKey: "messageType")
//    }
//}

//class PlayerData: GameData {
//    var name: String!
//    var target: Target!
//    var position: CGPoint!
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case target
//        case position
//    }
//
//    init(name: String, target: Target, position: CGPoint) {
//        super.init(messageType: .PLAYER_MESSAGE)
//
//        self.name = name
//        self.target = target
//        self.position = position
//    }
//
//    required init?(coder aDecoder: NSCoder)
//    {
//        super.init(coder: aDecoder)
//
//        self.name = aDecoder.decodeObject(forKey: "name") as? String
//        self.target = aDecoder.decodeObject(forKey: "target") as? Target
//        self.position = aDecoder.decodeObject(forKey: "position") as? CGPoint
//    }
//
//    override func encode(with aCoder: NSCoder)
//    {
//        super.encode(with: aCoder)
//
//        aCoder.encode(self.name, forKey: "name")
//        aCoder.encode(self.target, forKey: "target")
//        aCoder.encode(self.position, forKey: "position")
//    }
//}

//class GuestData: GameData {
//    override init(messageType: MessageType) {
//        super.init(messageType: .GUEST_MESSAGE)
//    }
//}

