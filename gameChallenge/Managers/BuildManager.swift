//
//  BuildManager.swift
//  gameChallenge
//
//  Created by Felipe Melo on 10/31/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit

class BuildManager {
    // Constants
    static let shared: BuildManager = BuildManager()
    let networkingEngine: MultiplayerNetworking = MultiplayerNetworking()
    
    private init() {
        
    }
    
    private func encodeData(gameData: GameData) -> String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(gameData)
        return String(data: data, encoding: .utf8)!
    }
    
    func sendBuildData(messageType: MessageType, centerPoint: CGPoint) {
        let gameData = GameData(messageType: messageType, name: nil, target: nil, state: nil, guestIndex: nil, centerPoint: centerPoint)
        let dataStr = self.encodeData(gameData: gameData)
        
        self.networkingEngine.sendData(data: Data(base64Encoded: dataStr.toBase64())!)
    }
    
    func removeDirty(centerPoint: CGPoint) {
        for floor in GameModel.shared.hotel.floors {
            floor.value.tryRemoveDirty(centerPoint: centerPoint)
        }
    }
}
