//
//  GameScene.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 18/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit
import GameplayKit

/*class TeleporterButton: SKSpriteNode {
    var floor : Int!
    
    init(floor : Int, position: CGPoint)
    {
        let texture = SKTexture(imageNamed: "elevador")
        super.init(texture: texture, color: .white, size: texture.size())
        self.position = position
        self.floor = floor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TeleporterSelector: SKSpriteNode {
    
    let columns : Int = 3
    let width : CGFloat = 85
    let height : CGFloat = 85
    let offSet : CGPoint = CGPoint(x: -85, y: -90)
    
    init(position: CGPoint, currentFloor: Int)
    {
        let texture = SKTexture(imageNamed: "elevador_frame")
        super.init(texture: texture, color: .white, size: texture.size())
        self.alpha = 0
        self.setScale(2)
        self.position = position
        
        createButtons(at: .zero)
    }
    
    func showTeleporter()
    {
        if let scene = scene as? GameScene
        {
            scene.selection = false
        }
        
        UIView.animate(withDuration: 2) {
            self.alpha = 1
        }
    }
    
    func createButtons(at position : CGPoint)
    {
        var i = 0
        for bt in GameModel.shared.hotel.floors.keys
        {
            let pos = offSet + CGPoint(x: position.x + CGFloat(i%columns)*width, y: position.y + CGFloat(i/columns)*height)
            let button = TeleporterButton(floor: bt, position: pos)
            self.addChild(button)
            i += 1
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        print("tocou teleporter")
        let position = pos - self.position - offSet
        print(position)
        
        for child in children
        {
            print(child.position)
            let nodes = child.nodes(at: position)
            print(nodes)
            if child.contains(position)
            {
                let c = child as! TeleporterButton
                print(c.floor)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}*/

class GameScene: SKScene, FloatActionSelectorDelegate, TeleporterDelegate {

    static let SCENE_WIDTH : CGFloat = 2048
    static let SCENE_HEIGHT : CGFloat = 1152
    
    var actionSelector : FloatActionSelector?
    var player : Player!
    var lastPosition : CGPoint!
    var beganTouchPosition : CGPoint!
    var xPos : CGFloat!
    var currentFloor : Int!
    var selection : Bool = true
    var yCamera : CGFloat = 0
    
    override func didMove(to view: SKView) {
        GameModel.shared.hotel.buildHotel(to: self)
        player = GameModel.shared.players.first!
        player.createNode()
        
        player.playerNode?.addNode(to: self, position: .zero)
        
        currentFloor = player.floor
        //choseFloor(floor: currentFloor)
        
        targetCamera(target: (player.playerNode?.position)!)
        
        GameModel.shared.teleporter.delegate = self
        
        self.size.width = GameModel.shared.hotel.getMaxWidth()
        
        //teleporter = TeleporterSelector(position: camera!.position + CGPoint(x: 100, y: 0), currentFloor: currentFloor)
        //addChild(teleporter)
        
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
        
        GuestManager.shared.setup(gameScene: self, maxGuestsSpawn: 10)
    }
    
    func selectFloor()
    {
        GameModel.shared.teleporter.showTeleporter()
    }
    
    func choseFloor(floor: Int) {
        currentFloor = floor
        player.setFloor(floor: floor)
        updateYCamera(floor: floor)
        targetCamera(target: (player.playerNode?.position)!)
        //GameModel.shared.hotel.buildAndRemove(to: self, floorID: floor)
        //self.size.width = GameModel.shared.hotel.getMaxWidth()
        
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
    
    func updateYCamera(floor floorID: Int)
    {
        if let floor = GameModel.shared.hotel.loadFloor(floorID: floorID)
        {
            self.yCamera = floor.getTeleporterPosition().y + (GameScene.SCENE_HEIGHT/2)
            print(yCamera)
        }
    }
    
    func targetCamera(target : CGPoint)
    {
        if let camera = self.camera
        {
            var xCamera = target.x
            xCamera = CGFloat.maximum(xCamera, 1024)
            xCamera = CGFloat.minimum(xCamera, self.size.width-1024)
            //camera.position = CGPoint(x: pos_cam_x, y: (self.size.height/2))
            if yCamera == 0
            {
                updateYCamera(floor: player.floor)
            }
            camera.position = CGPoint(x: xCamera, y: yCamera)// + (size/2))
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        guard selection else {
            return
        }
        
        //if !(actionSelector?.frame.contains(pos))!
        //if !((actionSelector?.hitTest(pos, with: nil)) != nil)
        beganTouchPosition = pos
        xPos = pos.x
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        guard selection else {
            return
        }
        
        if let camera = self.camera
        {
            var pos_cam_x = camera.position.x + (xPos - pos.x)
            pos_cam_x = CGFloat.maximum(pos_cam_x, 1024)
            pos_cam_x = CGFloat.minimum(pos_cam_x, self.size.width-1024)
            camera.position = CGPoint(x: pos_cam_x, y: yCamera)
            //targetCamera(target: CGPoint(x: pos_cam_x, y: camera.position.y))
            xPos = pos.x
        }
    }

    func touchUp(atPoint pos : CGPoint) {
        
        guard selection else {
            return
        }
        
        if pos.distance(to: beganTouchPosition) < 100
        {
            if (actionSelector?.isHidden)!// || pos.distance(to: lastPosition) > 100
            {
                lastPosition = pos
                var actions : [ActionTypes] = []
                
                if let floor = GameModel.shared.hotel.loadFloor(floorID: currentFloor)
                {
                    actions = floor.availableActions(at: pos)
                }
                if actions.count > 0
                {
                    if actions.count == 1 && actions[0] == .WALK_TO
                    {
                        actionSelector?.selectAction(action: .WALK_TO)
                    }
                    else
                    {
                        actionSelector?.setActions(actions: actions)
                        actionSelector?.show(at: self.convertPoint(toView: pos))
                    }
                }
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
        
        for t in touches {
            //if !selection { self.teleporter.touchDown(atPoint: t.location(in: self)) }
            self.touchDown(atPoint: t.location(in: self)) }
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

// MARK: GuestManagerDelegate
extension GameScene: GuestManagerDelegate {
    func spawnGuest() -> Guest {
        let currentFloor = GameModel.shared.hotel.loadFloor(floorID: player.floor)!
        let guestPosition = currentFloor.getReceptionPosition()
        
        let guest = Guest(profile: Profile(name: "Teste"))
        guest.createNode()
        
        guest.guestNode?.addNode(to: self, position: guestPosition)
        
        return guest
    }
}
