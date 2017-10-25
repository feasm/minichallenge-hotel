//
//  Player.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 25/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

class Player : CommonData, StateMachineDelegate
{
    var playerNode : PlayerNode?
    
    func didChangeState(from: PlayerState, to: PlayerState) {
        state = to
    }
    
    init() {
        super.init(id: "", name: "", floor: 0, room: -1)
    }
   
    func createNode()
    {
        playerNode = PlayerNode(texture: nil, color: .yellow, size: CGSize(width: 180, height: 300))
    }
}

class PlayerNode: BaseNode {
    
}
