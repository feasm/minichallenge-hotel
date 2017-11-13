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
    
    func createPlayers() {
        GKPlayer.loadPlayers(forIdentifiers: (GameKitHelper.shared.match?.playerIDs)!) { (player, error) in
            guard error == nil else {
                print("Error retrieving player info: \(String(describing: error?.localizedDescription))")
                return
            }
            self.setLocalPlayer()
            self.setOtherPlayers()
        }
    }
    
    private func setLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        let firstPlayer = GameManager.shared.player!
        
        firstPlayer.id = localPlayer.playerID
        firstPlayer.name = localPlayer.alias
    }
    
    private func setOtherPlayers() {
        for player in (GameKitHelper.shared.match?.players)! {
            let newPlayer = Player(position: .zero)
            newPlayer.id = player.playerID
            newPlayer.name = player.alias
            GameManager.shared.addPlayer(player: newPlayer)
        }
    }
    
    func encodeData(gameData: GameData) -> String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(gameData)
        return String(data: data, encoding: .utf8)!
    }
}
