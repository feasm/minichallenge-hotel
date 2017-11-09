//
//  BaseState.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 08/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit

class Target: Codable
{
    var position : CGPoint?
    var tile : CGPoint?
    var room : Int?
    
    init(position: CGPoint? = nil, tile: CGPoint? = nil, room: Int? = nil) {
        self.position = position
        self.tile = tile
        self.room = room
    }
}

class BaseState: GKState {
    
    private(set) var entity : BaseEntity
    var target : Target?
    
    init(entity: BaseEntity) {
        self.entity = entity
        super.init()
    }
    
}
