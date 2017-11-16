//
//  WalkState.swift
//  GamePlayTest
//
//  Created by Adonay Puszczynski on 10/10/17.
//  Copyright © 2017 Rodrigo Salles Stefani. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class WalkState: BaseState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is IdleState.Type:
            return true
        case is WalkState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?)
    {
        if entity.target != nil {
            self.target = entity.target
            //sprite.run(SKAction.move(to: targetPos, duration: 0.3))
            if let vc = entity.component(ofType: VisualComponent.self) {
                if let _ = previousState as? IdleState
                {
                    vc.sprite.color = UIColor.blue
                }
                
                vc.sprite.run(SKAction.move(to: (target?.position)!, duration: 0.1)) {
                    self.entity.target = nil
                    self.stateMachine?.enter(IdleState.self)
                    /*if let player = self.entity as? Player {
                        if player.direction == .NONE {
                            self.stateMachine?.enter(IdleState.self)
                        }
                        else {
                            self.stateMachine?.enter(WalkState.self)
                        }
                    }*/
                }
            }
        }
        else
        {
            self.stateMachine?.enter(IdleState.self)
        }
    }
}
