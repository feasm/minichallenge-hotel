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
    private(set) var lastDirection : MovementDirection = .NONE
    private(set) var backPosition : CGPoint!
    var id: String?
    var name: String?
    
    init(position: CGPoint) {
        super.init()
        
        let vc = VisualComponent(position: position, image: "main_char")
        backPosition = position
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
        updateBackPosition()
        if direction != .NONE
        {
            moveToDirection(direction: self.direction)
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
    
    func updateBackPosition()
    {
        if let vc = component(ofType: VisualComponent.self)
        {
            let current = BuildManager.tilePosition(position: vc.sprite.position)
            var back = CGPoint.zero
            let distance : Int = 1
            switch self.lastDirection
            {
            case .UP:
                back = current + CGPoint(x: 0, y: -distance)
            case .DOWN:
                back = current + CGPoint(x: 0, y: distance)
            case .RIGHT:
                back = current + CGPoint(x: -distance, y: 0)
            case .LEFT:
                back = current + CGPoint(x: distance, y: 0)
            default:
                return
            }
            self.backPosition = BuildManager.tilePosition(tile: back)
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
    
    func moveToDirection(direction : MovementDirection, broadcast: Bool = true)
    {
        self.direction = direction
        
        var dx : Int = 0
        var dy : Int = 0
        
        switch direction {
        case .NONE:
            target = nil
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
        
        self.lastDirection = direction
        
        updateDirection()
        
        if let vc = component(ofType: VisualComponent.self)
        {
            let targetPos = GameManager.shared.movementPositionByTile(from: vc.sprite.position, tile: CGPoint(x: dx, y: dy))
            target = Target(position : targetPos)
            stateMachine?.enter(WalkState.self)
        }

        //vc.movePlayer(to: CGPoint(x: dx, y: dy))
        
        if GameManager.MULTIPLAYER_ON && broadcast {
            MultiplayerNetworking.shared.sendPlayerData(player: self)
        }
    }
    
    func moveToTarget(target: Target) {
        self.target = target
        stateMachine?.enter(WalkState.self)
    }
    
    func updateName() {
        if let vc = component(ofType: VisualComponent.self) {
            vc.addName(name: self.name!)
        }
    }
}
