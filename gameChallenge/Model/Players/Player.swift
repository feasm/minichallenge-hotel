//
//  Player.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 25/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit
import SpriteKit

class Target
{
    var position : CGPoint?
    var floor : Int?
    var room : Int?
    init(position: CGPoint? = nil, floor: Int? = nil, room: Int? = nil) {
        self.position = position
        self.floor = floor
        self.room = room
    }
}

class Player : CommonData, StateMachineDelegate, BaseNodeDelegate
{
    var playerNode : PlayerNode?
    
    func didChangeState(from: PlayerState, to state: PlayerState) {
        self.state = state
        switch self.state as PlayerState {
        case .WALKING:
            self.actions = [Action(type: .WALK_TO, actions: [SKAction.walkTo(from: (playerNode?.position)!, to: target.position!, speed: 8)])]
            playerNode?.applyAction(nextAction()!)
        case .GO_TO_FLOOR:
            self.actions = [Action(type: .WALK_TO, actions: [SKAction.walkTo(from: (playerNode?.position)!, to: target.position!, speed: 8)])]
            playerNode?.applyAction(nextAction()!)
        default:
            return
        }
    }
    
    func actionEnded(action: Action) {
        print("Chegou em action ended")
        if let playerNode = playerNode
        {
            if actions.count > 0
            {
                playerNode.applyAction(nextAction()!)
            }
            else
            {
                self.setState(state: .WAITING_FOR_ACTION)
            }
        }
    }
    
    init() {
        super.init(id: "", name: "", floor: 0, room: -1)
        self.stateMachine.delegate = self
    }
   
    func createNode()
    {
        playerNode = PlayerNode(texture: nil, color: .blue, size: CGSize(width: 180, height: 300))
        playerNode?.delegate = self
    }
}

class PlayerNode: BaseNode {
    
}
