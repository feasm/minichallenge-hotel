//
//  Player.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 25/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit
import SpriteKit

class Target: Codable
{
    var position : CGPoint?
    var floor : Int?
    var room : Int?
    
    init(position: CGPoint? = nil, floor: Int? = nil, room: Int? = nil) {
        self.position = position
        self.floor = floor
        self.room = room
    }
}

class Player : CommonData, StateMachineDelegate, BaseNodeDelegate
{
    var playerNode : PlayerNode?
    
    static let MIN_PLAYER_SPEED : CGFloat = 8
    
    func didChangeState(from: PlayerState, to state: PlayerState) {
        self.state = state
        switch self.state as PlayerState {
        case .CLEANING_FLOOR:
            if let build = GameModel.shared.hotel.loadFloor(floorID: self.floor)?.getBuilding(at: target.position!)
            {
                let position = build.position + build.centerPoint
                self.actions = [Action(type: .WALK_TO, actions: [SKAction.walkTo(from: (playerNode?.position)!, to: position, speed: Player.MIN_PLAYER_SPEED)]), Action(type: .CLEAN_FLOOR, actions: [SKAction.wait(forDuration: 3)]), Action(type: .NONE, actions: [SKAction.run {
                        build.removeAttribute(.DIRTY_FLOOR)
                    }])]
                playerNode?.applyAction(nextAction()!)
            }
            else
            {
                self.setState(state: .WAITING_FOR_ACTION)
            }
            
        case .WALKING:
            self.actions = [Action(type: .WALK_TO, actions: [SKAction.walkTo(from: (playerNode?.position)!, to: target.position!, speed: Player.MIN_PLAYER_SPEED)])]
            playerNode?.applyAction(nextAction()!)
        case .GO_TO_FLOOR:
            let teleporter = GameModel.shared.hotel.loadFloor(floorID: self.floor)?.getTeleporterPosition()
            //let teleporterEnd = GameModel.shared.hotel.loadFloor(floorID: self.target.floor!)?.getTeleporterPosition()
            self.actions = [Action(type: .WALK_TO, actions: [SKAction.walkTo(from: (playerNode?.position)!, to: teleporter!, speed: Player.MIN_PLAYER_SPEED)]), Action(type: .CHANGE_FLOOR, actions: [ SKAction.run {
        
            self.playerNode?.gameScene?.selectFloor()
            //pega o player jogador e seta o floor para o self.target.floor!
            //self.playerNode?.gameScene?.chooseFloor(floor: self.target.floor!)
        }])]
            playerNode?.applyAction(nextAction()!)
        default:
            return
        }
        
    }
    
    func actionEnded(action: Action) {
        if let playerNode = playerNode
        {
            if actions.count > 0
            {
                playerNode.applyAction(nextAction()!)
            }
            else
            {
                self.playerNode?.stopAnimation()
                self.setState(state: .WAITING_FOR_ACTION)
            }
        }
    }
    
    init() {
        
        super.init(id: "", name: "", floor: 0, room: -1)
        self.stateMachine.delegate = self
    }
   
    func createNode()
    {
        let texture = SKTexture(imageNamed: "walk_1")
        playerNode = PlayerNode(texture: texture, color: .blue, size: texture.size())//CGSize(width: 225, height: 400))
        let playerName = SKLabelNode(fontNamed: "Arial")
        playerName.text = self.name
        playerName.fontColor = SKColor.white
        playerName.fontSize = 50
        playerName.position = CGPoint(x: 0, y: (playerNode?.frame.size.height)! + 10)
        playerNode?.addChild(playerName)
        playerNode?.delegate = self
    }
    
    override func setFloor(floor floorID: Int)
    {
        super.setFloor(floor: floorID)
        self.playerNode?.setPositionByFloor(nil, floor: floorID)
    }
}

class PlayerNode: BaseNode {
    override func applyAction(_ action: Action) {
        super.applyAction(action)
        var textures : [SKTexture] = []
        for i in 1...4
        {
            textures.append(SKTexture(imageNamed: "walk_\(i)"))
        }
        
        if (action.type == .WALK_TO)
        {
            self.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.3)), withKey: "animation")
        }
    }
}
