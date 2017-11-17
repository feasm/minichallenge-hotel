//
//  Guest.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 08/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit
import SpriteKit

enum GuestType : String {
    case ATMOSPHERE = "atmosphere"
    case BIRDALINE = "birdalien"
    case BOCUDO = "bocudo"
    case GASEOUS = "gaseous"
    case NARIGUDALIEN = "narigudalien"
    case ORELHAR = "orelhar"
    case SUJEIROSO = "sujeiroso"
}

class Guest: BaseEntity {
    var type : GuestType!
    var following : BaseEntity?
    
    init(position: CGPoint, type : GuestType) {
        super.init()
        
        let vc = VisualComponent(position: position, image: type.rawValue)
        vc.sprite.anchorPoint = vc.getAnchorPoint()
        vc.setPhysics(true, size: CGSize(width: 96, height: 96))
        self.addComponent(vc)
        
        stateMachine = GKStateMachine(states: [WaitingPlayerActionState(entity: self), PathState(entity: self)])
        stateMachine?.enter(WaitingPlayerActionState.self)
        
        self.type = type
        let wi = WorldInteraction()
        self.addComponent(wi)
        
        switch type {
        case .ATMOSPHERE:
            break
        case .BIRDALINE:
            break
        case .BOCUDO:
            wi.addByType(.NOISY)
            break
        case .GASEOUS:
            break
        case .NARIGUDALIEN:
            break
        case .ORELHAR:
            break
        case .SUJEIROSO:
            wi.addByType(.DIRTY_FLOOR)
            break
        }
        
//        self.following = GameManager.shared.player
    }

    override func update(deltaTime seconds: TimeInterval) {
        updateZPosition()
        if let wi = component(ofType: WorldInteraction.self)
        {
            wi.performInteraction()
        }
        
        if let following = following as? Player
        {
            if let followVC = following.component(ofType: VisualComponent.self)
            {
                if let guestVC = component(ofType: VisualComponent.self)
                {
                    let distance = followVC.sprite.position.distance(to: guestVC.sprite.position)
                    if distance > 4*96
                    {
                        self.target = Target(position: following.backPosition)
                        self.stateMachine?.enter(PathState.self)
                    }
                    else
                    {
                        let action = SKAction.move(to: following.backPosition, duration: 0.2)
                        action.timingMode = .linear
                        guestVC.sprite.run(action)
                    }
                }
            }
        }
    }
    
    func updateZPosition()
    {
        if let vc = component(ofType: VisualComponent.self)
        {
            let zPosition = (-vc.sprite.position.y + (BuildManager.shared.getRoomSize().height/2)) / BuildManager.TILE_SIZE
            vc.sprite.zPosition = zPosition
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
