//
//  Guest.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 08/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit
import SpriteKit

class Guest: BaseEntity {
    
    init(position: CGPoint) {
        super.init()
        
        let sprites = ["atmosphere", "birdalien", "bocudo", "gaseous", "narigudalien", "orelhar", "sujeiroso"]
        let sprite = sprites.chooseOne
        let vc = VisualComponent(position: position, image: sprite)
        vc.sprite.anchorPoint = vc.getAnchorPoint()
        vc.setPhysics(true, size: CGSize(width: 96, height: 96))
        self.addComponent(vc)
        
        let wi = WorldInteraction()
        self.addComponent(wi)
        
        wi.addByType(.DIRTY_FLOOR)
        
        stateMachine = GKStateMachine(states: [WaitingPlayerActionState(entity: self), PathState(entity: self)])
        stateMachine?.enter(WaitingPlayerActionState.self)
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
            GameManager.shared.sendToRoom(guest: self, to: 1)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        updateZPosition()
        if let wi = component(ofType: WorldInteraction.self)
        {
            wi.performInteraction()
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
