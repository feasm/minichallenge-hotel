//
//  PathState.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 09/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit

class PathState : BaseState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is WaitingPlayerActionState.Type:
            return true
        case is IdleState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?)
    {
        if entity.target != nil
        {
            self.target = entity.target
            //sprite.run(SKAction.move(to: targetPos, duration: 0.3))
            if let vc = entity.component(ofType: VisualComponent.self)
            {
                if let _ = previousState as? IdleState
                {
                    vc.sprite.color = UIColor.blue
                }
                
                let targetPos = GameManager.shared.movementPositionByTile(from: vc.sprite.position, tile: (target?.tile)!)
                vc.sprite.run(SKAction.move(to: targetPos, duration: 0.3))
                {
                    if let player = self.entity as? Player
                    {
                        player.stateMachine?.enter(IdleState.self)
                    }
                    
                    if let guest = self.entity as? Guest
                    {
                        guest.stateMachine?.enter(WaitingPlayerActionState.self)
                    }
                }
            }
        }
    }
    
}