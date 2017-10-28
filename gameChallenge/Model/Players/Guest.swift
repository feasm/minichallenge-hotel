//
//  Guest.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 24/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

class Guest: CommonData, StateMachineDelegate {
    var guestNode : GuestNode?
    private var profile : Profile!
    
    func didChangeState(from: PlayerState, to: PlayerState) {
        state = to
    }
    
    init(profile: Profile)
    {
        super.init(id: profile.name, name: profile.name, floor: 0, room: -1)
        self.profile = profile
    }
    
    func createNode()
    {
        guestNode = GuestNode(texture: nil, color: .yellow, size: CGSize(width: 180, height: 300))
    }

}

class GuestNode : BaseNode
{
    
}

