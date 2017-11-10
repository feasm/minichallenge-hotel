//
//  Guest.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 08/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit
import SpriteKit

class Guest: BaseEntity {
    override init() {
        super.init()
    }
    
    init(position: CGPoint) {
        super.init()
        
        let vc = VisualComponent(position: position, color: .yellow, physics: true)
        vc.sprite.zPosition = 10
        self.addComponent(vc)
        
        stateMachine = GKStateMachine(states: [WaitingPlayerActionState(entity: self), PathState(entity: self)])
        stateMachine?.enter(WaitingPlayerActionState.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
