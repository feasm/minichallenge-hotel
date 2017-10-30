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
    func matchEnded()
    func gameOver(player1Won: Bool)
    func setPlayerAliases (playerAliases: NSArray)
}

enum GameState: UInt8 {
    case WAITING_FOR_MATCH = 0
    case WAITING_FOR_RANDOM_NUMBER
    case WAITING_FOR_START
    case ACTIVE
    case DONE
}

class MultiplayerNetworking {
    var ourRandomNumber: UInt32?
    var gameState: GameState?
    var isPlayer1: Bool?
    var receivedAllNumbers: Bool?
    var orderOfPlayers: NSMutableArray?
    
    init() {
        self.ourRandomNumber = arc4random()
        self.gameState = .WAITING_FOR_MATCH
        self.orderOfPlayers = NSMutableArray(array: [])
        self.orderOfPlayers?.add(GKLocalPlayer())
    }
    
    func matchStarted() {
        print("Match has started successfully")
        
        if self.receivedAllNumbers! {
            self.gameState = .WAITING_FOR_START
        } else {
            self.gameState = .WAITING_FOR_RANDOM_NUMBER
        }
        
        self.sendRandomNumber()
        self.tryStartGame()
    }
    
    func sendRandomNumber() {
        let data = Data(bytes: [2])
        self.sendData(data: data)
    }
    
    func tryStartGame() {
        if self.isPlayer1! && self.gameState == .WAITING_FOR_START {
            self.gameState = .ACTIVE
            self.sendGameBegin()
        }
    }
    
    func processReceiveRandomNumber(randomNumberDetails: NSDictionary) {
        
    }
    
    func isLocalPlayerPlayer1() -> Bool {
        return false
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

