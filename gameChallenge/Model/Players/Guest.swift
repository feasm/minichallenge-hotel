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
        case .LEAVE_HOTEL:
            let teleporter = GameModel.shared.hotel.loadFloor(floorID: self.floor)?.getTeleporterPosition()
            
            let teleporter_first = GameModel.shared.hotel.loadFloor(floorID: 0)?.getTeleporterPosition()
            let hotel_exit = teleporter_first! + CGPoint(x: 2200, y: 0)
            
            self.actions = [
                Action(type: .WALK_TO, actions: [SKAction.walkTo(from: (guestNode?.position)!, to: teleporter!, speed: Guest.MIN_GUEST_SPEED)]),
                Action(type: .CHANGE_FLOOR, actions: [SKAction.wait(forDuration: 2), SKAction.run {
                        self.guestNode?.alpha = 0
                        self.setFloor(floor: 0)
                }]),
                Action(type: .WALK_TO, actions: [SKAction.run {
                    self.guestNode?.alpha = 1
                    }]),
                Action(type: .WALK_TO, actions: [SKAction.walkTo(from: teleporter_first!, to: hotel_exit, speed: Guest.MIN_GUEST_SPEED)])
            ]
            guestNode?.applyAction(nextAction()!)
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
            self.actions = [
                Action(type: .WALK_TO, actions: [SKAction.walkTo(from: (guestNode?.position)!, to: roomPos!, speed: Guest.MIN_GUEST_SPEED)]),
                Action(type: .WALK_TO, actions: [SKAction.run {
                        self.setState(state: .ENTER_ROOM)
                    }])
            ]
            guestNode?.applyAction(nextAction()!)
        case .ENTER_ROOM:
            self.actions = [
                Action(type: .NONE, actions: [SKAction.run {
                    self.enterRoom()
                }])
            ]
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
    
    func enterRoom() {
//        let fadeOut = SKAction.fadeOut(withDuration: 1)
//        let moveUp = SKAction.moveBy(x: 0, y: 100, duration: 1)
//        let enterRoom = SKAction.group([
//                fadeOut,
//                moveUp
//        ])
//        self.guestNode?.run(enterRoom)
        
        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(leaveHotel), userInfo: nil, repeats: false)
    }
    
    @objc func leaveHotel() {
        self.target = Target(position: GuestManager.shared.queueManager.startPosition + CGPoint(x: 1500, y: 0), floor: 0)
        self.setState(state: .LEAVE_HOTEL)
        
        GameServer.shared.sendGuestData(target: self.target, state: .LEAVE_HOTEL, guestIndex: self.index!)
    }
    
    init(profile: Profile)
    {
        super.init(id: profile.name, name: profile.name, floor: 0, room: -1)
        self.profile = profile
        self.stateMachine.delegate = self
    }
    
    func createNode()
    {
        let texture = SKTexture(imageNamed: "alien_walk1")
        guestNode = GuestNode(texture: texture, color: .yellow, size: texture.size())
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
    
    override func applyAction(_ action: Action) {
        super.applyAction(action)
        var textures : [SKTexture] = []
        for i in 1...4
        {
            textures.append(SKTexture(imageNamed: "alien_walk\(i)"))
        }
        
        if (action.type == .WALK_TO)
        {
            self.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.2)), withKey: "animation")
        }
    }
}
