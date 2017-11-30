//
//  MultiplayerNetworking.swift
//  GameCenterTest
//
//  Created by Felipe Melo on 10/26/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//
import Foundation
import GameKit

protocol MultiplayerNetworkingProtocol {
    
}

class MultiplayerNetworking {
    static let shared: MultiplayerNetworking = MultiplayerNetworking()
    
    init() {
        
    }
}

// MARK: GameStart
extension MultiplayerNetworking {
    func matchStarted() {
        print("Match has started successfully")
        
        self.tryStartGame()
    }
    
    func tryStartGame() {
        if true {
            self.sendGameBegin()
        }
    }
    
    func sendGameBegin() {
        var playerNames = [String]()
        
        for player in GameManager.shared.players {
            playerNames.append(player.alias)
        }
        
        let gameData = GameData(messageType: .GAME_BEGIN, playerNames)
        self.sendData(gameData)
    }
}

// MARK: GameScene
extension MultiplayerNetworking {
    private func encodeData(gameData: GameData) -> String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(gameData)
        return String(data: data, encoding: .utf8)!
    }
    
    func sendCharacterData(character: CharactersEnum) {
        let gameData = GameData(messageType: .CHARACTER_CHANGED, GameManager.shared.localNumber, character)
        self.sendData(gameData)
    }
    
    func sendReady(_ readyStatus: PlayerStatusEnum) {
        let gameData = GameData(messageType: .PLAYER_READY, GameManager.shared.localNumber, readyStatus)
        self.sendData(gameData)
    }
    
    func sendPlayerData(player: Player) {
//        if let vc = player.component(ofType: VisualComponent.self) {
//            let gameData = GameData(messageType: .PLAYER_MESSAGE, name: player.name!, target: player.target, position: vc.sprite.position)
//
//            self.sendData(gameData)
//        }
    }
    
    func sendActionData(messageType: MessageType) {
        let gameData = GameData(messageType: messageType)
        self.sendData(gameData)
    }
    
    func sendChangeMap(_ currentPosition: Int) {
        let gameData = GameData(messageType: .CHANGE_MAP, currentPosition)
        self.sendData(gameData)
    }
    
    func sendMapBegin() {
        let gameData = GameData(messageType: .START_MAP)
        self.sendData(gameData)
    }
    
    func sendPlayerMovement(name: String, position: CGPoint, rotation: CGFloat) {
        let gameData = GameData(messageType: .PLAYER_MOVEMENT, name: name, position: position, rotation: rotation)
        self.sendData(gameData)
    }
    
    func sendPlayerDestroyed(name: String, reason: DeathReason, defeat: String?) {
        let gameData = GameData(messageType: .PLAYER_DESTROYED, name: name, reason: reason, defeat: defeat)
        self.sendData(gameData)
    }
    
    func sendData(_ gameData: GameData) {
        do {
            let dataStr = self.encodeData(gameData: gameData)
            
            try GameKitHelper.shared.match?.sendData(
                toAllPlayers: Data(base64Encoded: dataStr.toBase64())!,
                with: .reliable
            )
        } catch {
            print("Error sending data")
        }
    }
}
