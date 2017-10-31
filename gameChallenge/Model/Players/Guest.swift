//
//  Guest.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 24/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit
import SpriteKit

class Guest: CommonData, StateMachineDelegate, BaseNodeDelegate {
    var guestNode : GuestNode?
    var index : Int?
    private var profile : Profile!
    
    static let MIN_GUEST_SPEED : CGFloat = 2
    
    func didChangeState(from: PlayerState, to: PlayerState) {
        state = to
        switch self.state as PlayerState {
        case .GO_TO_FLOOR:
            let teleporter = GameModel.shared.hotel.loadFloor(floorID: self.floor)?.getTeleporterPosition()
            //let teleporterEnd = GameModel.shared.hotel.loadFloor(floorID: self.target.floor!)?.getTeleporterPosition()
            self.actions = [Action(type: .WALK_TO, actions: [SKAction.walkTo(from: (guestNode?.position)!, to: teleporter!, speed: Guest.MIN_GUEST_SPEED)]), Action(type: .CHANGE_FLOOR, actions: [SKAction.wait(forDuration: 2), SKAction.run {
                self.guestNode?.alpha = 0
                self.setFloor(floor: self.target.floor!)
                }]), Action(type: .WALK_TO, actions: [SKAction.run {
                    self.guestNode?.alpha = 1
                    self.setState(state: .GO_TO_ROOM)
                    }])]
             guestNode?.applyAction(nextAction()!)
        case .GO_TO_ROOM:
            let roomPos = GameModel.shared.hotel.loadFloor(floorID: self.target.floor!)?.getRoomPosition(room: target.room!)
            self.actions = [Action(type: .WALK_TO, actions: [SKAction.walkTo(from: (guestNode?.position)!, to: roomPos!, speed: Guest.MIN_GUEST_SPEED)])]
            guestNode?.applyAction(nextAction()!)
        default:
            return
        }
    }
    
    func actionEnded(action: Action) {
        if let guestNode = guestNode
        {
            if actions.count > 0
            {
                guestNode.applyAction(nextAction()!)
            }
            else
            {
                self.setState(state: .WAITING_FOR_ACTION)
            }
        }
    }
    
    override func setFloor(floor floorID: Int)
    {
        super.setFloor(floor: floorID)
        self.guestNode?.setPositionByFloor(nil, floor: floorID)
    }
    
    init(profile: Profile)
    {
        super.init(id: profile.name, name: profile.name, floor: 0, room: -1)
        self.profile = profile
        self.stateMachine.delegate = self
    }
    
    func createNode()
    {
        guestNode = GuestNode(texture: nil, color: .yellow, size: CGSize(width: 180, height: 300))
        guestNode?.name = "guest"
        guestNode?.delegate = self
    }

}

class GuestNode : BaseNode
{
    override func setupPhysicsBody(size: CGSize) {
        super.setupPhysicsBody(size: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = 3
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 2
    }
}

