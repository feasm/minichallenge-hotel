//
//  FollowState.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 16/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit

class FollowState : BaseState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is WaitingPlayerActionState.Type:
            return true
        case is PathState.Type:
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
            if let player = GameManager.shared.findPlayer(name: (target?.player)!)
            {
                if let entity = self.entity as? Guest
                {
                    entity.following = player
                    self.entity.target = nil
                }
            }
        }
    }
}
