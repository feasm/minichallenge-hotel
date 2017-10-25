//
//  Player.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 23/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit
import SpriteKit

//Player

//PlayerData = Multipeer (x, y, state, floor)
//PlayerNode = SKNode (texture, actions, x_sprite, y_sprite)
//PlayerStats = Servidor (Nome, stats (xp, dinheiro, habilidades))

//Guests

//GuestsNode = SKNode
//GuestsStats = Servidor

//Hotel
//Floor -> [Buildings] -> [ActionsTypes]


class Player : PlayerStateMachineDelegate {
    
    private(set) var oldData : PlayerData?
    var playerData : PlayerData!
    {
        willSet
        {
            oldData = playerData
        }
        
        didSet
        {
            updatePlayer()
        }
    }
    
    var playerNode : PlayerNode?
    {
        didSet
        {
            updatePlayer()
        }
    }
    
    var playerStateMachine : PlayerStateMachine!
    
    init()
    {
        playerStateMachine = PlayerStateMachine(initial: .WAITING_FOR_ACTION)
    }
    
    func didCreateNode() -> Bool
    {
        return (playerNode != nil)
    }
    
    func createNode()
    {
        //playerNode = PlayerNode(imageNamed: "")
        playerNode = PlayerNode(texture: nil, color: .yellow, size: CGSize(width: 180, height: 400))
    }
    
    func applyAction(action: ActionTypes)
    {
        //playerNode?.applyAction()
    }
    
    func updatePlayer()
    {
        print(playerData?.floor ?? "Nil")
    }
    
    func didChangeState(from: PlayerState, to: PlayerState) {
        //
    }
}
