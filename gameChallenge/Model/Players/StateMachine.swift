//
//  PlayerStateMachine.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 23/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

enum PlayerState : String, Codable {
    case WALKING = "ps_walk"
    case WAITING_FOR_ACTION = "ps_waiting"
    case ON_THE_LINE = "ps_line"
    case GO_TO_FLOOR = "ps_gotofloor"
    case GO_TO_ROOM = "ps_gotoroom"
}

protocol StateMachineDelegate {
    func didChangeState(from: PlayerState, to: PlayerState)
}

class StateMachine {
    var delegate : StateMachineDelegate?
    var state : PlayerState!
    {
        didSet
        {
            previousState = oldValue
            delegate?.didChangeState(from: previousState, to: state)
        }
    }
    
    var previousState : PlayerState!
    
    init(initial state: PlayerState) {
        self.state = state
    }
    
    func currentState() -> PlayerState
    {
        return self.state
    }
    
    func changeState(new state: PlayerState)
    {
        self.state = state
    }
}
