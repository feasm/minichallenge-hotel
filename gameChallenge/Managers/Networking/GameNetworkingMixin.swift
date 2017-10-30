//
//  GameNetworkingMixin.swift
//  gameChallenge
//
//  Created by Felipe Melo on 10/30/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameKit

class GameNetworkingMixin {
    func createPlayers() {
        GKPlayer.loadPlayers(forIdentifiers: (GameKitHelper.shared.match?.playerIDs)!) { (player, error) in
            guard error == nil else {
                print("Error retrieving player info: \(error?.localizedDescription)")
                return
            }
            self.setLocalPlayer()
            self.setOtherPlayers()
        }
    }
    
    private func setLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        let firstPlayer = GameModel.shared.players.first!
        
        firstPlayer.id = localPlayer.playerID
        firstPlayer.name = localPlayer.alias
    }
    
    private func setOtherPlayers() {
        for player in (GameKitHelper.shared.match?.players)! {
            let newPlayer = Player()
            newPlayer.id = player.playerID
            newPlayer.name = player.alias
            GameModel.shared.players.append(newPlayer)
            
            newPlayer.createNode()
            newPlayer.playerNode?.addNode(to: GameKitHelper.shared.gameScene as! SKScene, position: .zero)
        }
    }
}
