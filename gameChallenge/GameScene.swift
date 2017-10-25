//
//  GameScene.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 18/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, FloatActionSelectorDelegate {
    
    var actionSelector : FloatActionSelector?
    var player : Player!
    var lastPosition : CGPoint!
    
    override func didMove(to view: SKView) {
        
        player = GameModel.shared.players.first!
        player.createNode()
        player.playerNode?.addNode(to: self, position: .zero)
        
        GameModel.shared.hotel.buildHotel(to: self)
        
        
        
        //player.createNode()
        //player.playerNode?.add(to: self)
        
        /*let reception = Building(name: "Recepcao", type: .RECEPTION)
        let stairs_0 = Building(name: "Stairs", type: .STAIRS)
        
        let floor = Floor(floor: CGPoint(x: 0, y: 0), buildings: [stairs_0, reception])
        
        let build = Building(name: "Teste", type: .STAIRS)
        let build2 = Building(name: "Teste3", type: .SIMPLE_ROOM)
        let build3 = Building(name: "Teste3", type: .SIMPLE_ROOM)
        
        let floor2 = Floor(floor: CGPoint(x: 0, y: 195), buildings: [build, build2, build3])
        
        floor.addBuildings(to: self)
        floor2.addBuildings(to: self)*/
    }
    
    func selectAction(action: ActionTypes) {
        print(action)
        switch action {
        case .WALK_TO:
            let action = SKAction.walkTo(from: (player.playerNode?.position)!, to: lastPosition, speed: 8)
            player.playerNode?.applyAction(action)
        default:
            return
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        //if !(actionSelector?.frame.contains(pos))!
        //if !((actionSelector?.hitTest(pos, with: nil)) != nil)
        if (actionSelector?.isHidden)! || pos.distance(to: lastPosition) > 100
        {
            lastPosition = pos
            actionSelector?.setActions(actions: [.CLEAN_FLOOR, .WALK_TO])
            actionSelector?.show(at: self.convertPoint(toView: pos))
        }
        /*else if pos.distance(to: lastPosition) > 100
        {
            actionSelector?.hide()
        }*/
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
