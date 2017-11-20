//
//  IdleState.swift
//  GamePlayTest
//
//  Created by Adonay Puszczynski on 10/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class IdleState: BaseState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is WalkState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        if let _ = previousState as? WalkState
        {
            if let vc = entity.component(ofType: VisualComponent.self)
            {
                vc.animate(name: "idle", repetition: false)
            }
        }
    }
}
