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
    
    init() {
        
    }
    
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
    
    func sendData(data: Data) {
        do {
            try GameKitHelper.shared.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("Error sending data")
        }
    }
}
