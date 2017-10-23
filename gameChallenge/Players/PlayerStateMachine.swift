//
//  PlayerStateMachine.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 23/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

enum PlayerState : String {
    case WALKING = "ps_walk"
    case WAITING_FOR_ACTION = "ps_waiting"
    case ON_THE_LINE = "ps_line"
}

protocol PlayerStateMachineDelegate {
    func willChangeState(from: PlayerState, to: PlayerState)
    func didChangeState(to state: PlayerState)
}

class PlayerStateMachine {
    var delegate : PlayerStateMachineDelegate?
    var state : PlayerState!
    {
        didSet
        {
            previousState = oldValue
            delegate?.willChangeState(from: previousState, to: state)
            delegate?.didChangeState(to: state)
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
