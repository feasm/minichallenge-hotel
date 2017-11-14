//
//  WITypeComponent.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 14/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit

enum WIType : String
{
    case DIRTY_FLOOR = "wi_dirty"
    case NOISY = "wi_noisy"
}

class WITypeComponent : GKComponent
{
    var type : WIType
    init(type : WIType) {
        self.type = type
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func performInteraction()
    {
        
    }
}

