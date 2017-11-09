//
//  BaseEntity.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 08/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit

class BaseEntity : GKEntity
{
    var target : Target?
    var stateMachine : GKStateMachine?
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
