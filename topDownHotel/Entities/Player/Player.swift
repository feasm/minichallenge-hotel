//
//  Player.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 07/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit

enum MovementDirection : String
{
    case UP = "dir_up"
    case DOWN = "dir_down"
    case LEFT = "dir_left"
    case RIGHT = "dir_right"
    case NONE = "dir_none"
}

class Player : BaseEntity
{
    private(set) var direction : MovementDirection = .NONE
    
    init(position: CGPoint) {
        super.init()
        
        let vc = VisualComponent(position: position, image: "main_char")
        vc.sprite.anchorPoint = vc.getAnchorPoint()
        vc.setPhysics(true, size: CGSize(width: 96, height: 96))
        self.addComponent(vc)

        stateMachine = GKStateMachine(states: [IdleState(entity: self), WalkState(entity: self)])
        stateMachine?.enter(IdleState.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        updateZPosition()
        if direction != .NONE
        {
            moveToDirection(direction: self.direction)
        }
    }
    
    func updateZPosition()
    {
        if let vc = component(ofType: VisualComponent.self)
        {
            let zPosition = (-vc.sprite.position.y + (BuildManager.sharedInstance.getRoomSize().height/2)) / BuildManager.TILE_SIZE
            vc.sprite.zPosition = zPosition
        }
    }
    
    func updateDirection()
    {
        if let vc = component(ofType: VisualComponent.self)
        {
            switch self.direction
            {
                case .LEFT: vc.sprite.xScale = -abs(vc.sprite.xScale)
                case .RIGHT: vc.sprite.xScale = abs(vc.sprite.xScale)
                default: return
            }
        }
    }
    
    func moveToDirection(direction : MovementDirection)
    {
        self.direction = direction
        
        var dx : Int = 0
        var dy : Int = 0
        
        switch direction {
        case .NONE:
            return
        case .DOWN:
            dy = -1
        case .UP:
            dy = 1
        case .LEFT:
            dx = -1
        case .RIGHT:
            dx = 1
       
        }
        
        updateDirection()
        
        target = Target(tile: CGPoint(x: dx, y: dy))
        stateMachine?.enter(WalkState.self)
    
        //vc.movePlayer(to: CGPoint(x: dx, y: dy))
    }
    
    
}



