//
//  Building.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 10/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit
import SpriteKit

enum BuildingType : String
{
    case SIMPLE_ROOM = "simple_room"
    case RECEPTION = "reception"
    case KITCHEN = "kitchen"
}

class Building : BaseEntity
{
    private(set) var position: CGPoint
    private(set) var type : BuildingType
    
    init(position: CGPoint, type: BuildingType) {
        self.position = position
        self.type = type
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
