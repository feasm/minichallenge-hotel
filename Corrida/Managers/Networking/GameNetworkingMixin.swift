//
//  GameNetworkingMixin.swift
//  gameChallenge
//
//  Created by Felipe Melo on 10/30/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//
import GameKit

class GameNetworkingMixin {
    let networkingEngine: MultiplayerNetworking = MultiplayerNetworking()
    
    func mapPlayers() {
        GKPlayer.loadPlayers(forIdentifiers: (GameKitHelper.shared.match?.playerIDs)!) { (players, error) in
            guard error == nil else {
                print("Error retrieving player info: \(String(describing: error?.localizedDescription))")
                return
            }
            
            self.setLocalPlayer()
            GameManager.shared.players.append(GameManager.shared.localPlayer)
            GameManager.shared.localNumber = 1
            self.setOtherPlayers(players!)
            
            MultiplayerNetworking.shared.sendGameBegin()
            
            self.setPlayerNames()
        }
    }
    
    func mapPlayers(_ playerNames: [String]) {
        setLocalPlayer()
        
        var index = 1
        for playerName in playerNames {
            let newPlayer = Player()
            newPlayer.alias = playerName
            
            GameManager.shared.players.append(newPlayer)
            
            if newPlayer.alias == GameManager.shared.localPlayer.alias {
                GameManager.shared.localNumber = index
            }
            index += 1
        }
        
        GKPlayer.loadPlayers(forIdentifiers: (GameKitHelper.shared.match?.playerIDs)!) { (players, error) in
            guard error == nil else {
                print("Error retrieving player info: \(String(describing: error?.localizedDescription))")
                return
            }
            
            if let gkPlayers = players {
                for gkPlayer in gkPlayers {
                    for player in GameManager.shared.players {
                        if player.alias == gkPlayer.alias {
                            player.id = gkPlayer.playerID!
                        }
                    }
                }
            }
            
            self.setPlayerNames()
        }
    }
    
    private func setLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        let firstPlayer = Player()
        firstPlayer.setup(id: localPlayer.playerID!, alias: localPlayer.alias!)
        
        GameManager.shared.localPlayer = firstPlayer
    }
    
    private func setOtherPlayers(_ players: [GKPlayer]) {
        for player in players {
            let newPlayer = Player()
            newPlayer.setup(id: player.playerID!, alias: player.alias!)
            GameManager.shared.players.append(newPlayer)
        }
    }
    
    private func setPlayerNames() {
        var playerNames: [String] = ["", "", ""]
        var index = 0
        for player in GameManager.shared.players {
            if player.alias != GameManager.shared.localPlayer.alias {
                playerNames[index] = player.alias
            } else {
                index += 1
            }
        }
        
        GameKitHelper.shared.prepareViewController?.setupPlayers(firstName: playerNames[0], secondName: playerNames[1], thirdName:  playerNames[2])
    }
}
