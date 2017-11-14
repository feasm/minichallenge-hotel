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
        let data = Data(bytes: [1])
        self.sendData(data: data)
    }
}

// MARK: GameScene
extension MultiplayerNetworking {
    private func encodeData(gameData: GameData) -> String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(gameData)
        return String(data: data, encoding: .utf8)!
    }
    
    func sendPlayerData(player: Player) {
        if let vc = player.component(ofType: VisualComponent.self) {
            let gameData = GameData(messageType: .PLAYER_MESSAGE, name: player.name!, target: player.target!, position: vc.sprite.position)
            let dataStr = self.encodeData(gameData: gameData)
            
            self.sendData(data: Data(base64Encoded: dataStr.toBase64())!)
        }
    }
    
    func sendData(data: Data) {
        do {
            try GameKitHelper.shared.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("Error sending data")
        }
    }
}
