//
//  GameScene.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 18/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit
import GameplayKit


class TeleporterSelector: SKSpriteNode {
    init(position: CGPoint, currentFloor: Int)
    {
        super.init(texture: SKTexture(imageNamed: "elevador_frame"), color: .white, size: CGSize())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GameScene: SKScene, FloatActionSelectorDelegate {
    
    var actionSelector : FloatActionSelector?
    var player : Player!
    var lastPosition : CGPoint!
    var beganTouchPosition : CGPoint!
    var xPos : CGFloat!
    
    override func didMove(to view: SKView) {
        
        //GameModel.shared.hotel.buildHotel(to: self)
        
        player = GameModel.shared.players.first!
        player.createNode()
        
        chooseFloor(floor: player.floor)
        player.playerNode?.addNode(to: self, position: .zero)
        
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
    
    func chooseFloor(floor id: Int)
    {
        if let camera = self.camera
        {
            camera.position = CGPoint(x: 0, y: 0)
        }
        GameModel.shared.hotel.buildAndRemove(to: self, floorID: id)
        self.size.width = GameModel.shared.hotel.getMaxWidth()
    }
    
    
    func selectAction(action: ActionTypes) {
        print(action)
        switch action {
        case .WALK_TO:
            player.target = Target(position: lastPosition)
            player.setState(state: .WALKING)
        case .USE_TELEPORTER:
            player.target = Target(floor: 1)
            player.setState(state: .GO_TO_FLOOR)
            //chooseFloor(floor: 1)
        default:
            return
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        //if !(actionSelector?.frame.contains(pos))!
        //if !((actionSelector?.hitTest(pos, with: nil)) != nil)
        beganTouchPosition = pos
        xPos = pos.x
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let camera = self.camera
        {
            var pos_cam_x = camera.position.x + (xPos - pos.x)
            pos_cam_x = CGFloat.maximum(pos_cam_x, 1024)
            pos_cam_x = CGFloat.minimum(pos_cam_x, self.size.width-1024)
            camera.position = CGPoint(x: pos_cam_x, y: (self.size.height/2))
            xPos = pos.x
            
        }
        
    }

    func touchUp(atPoint pos : CGPoint) {
        if pos.distance(to: beganTouchPosition) < 100
        {
            if (actionSelector?.isHidden)!// || pos.distance(to: lastPosition) > 100
            {
                lastPosition = pos
                actionSelector?.setActions(actions: [.USE_TELEPORTER, .WALK_TO])
                actionSelector?.show(at: self.convertPoint(toView: pos))
            }
            else if pos.distance(to: lastPosition) > 100
            {
                actionSelector?.hide()
            }
        }
        /*else
        {
            let speed = player.playerNode?.position.x.distance(to: pos)
        }*/
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
