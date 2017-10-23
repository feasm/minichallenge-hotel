//
//  GameScene.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 18/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit
import GameplayKit

enum BuildingType : String
{
    case SIMPLE_ROOM = "simple_room"
    case RECEPTION = "reception"
    case STAIRS = "stairs"
}

class Floor
{
    private var floorReference : CGPoint!
    private var buildingsTypes : [BuildingType] = []
    private var buildings : [Building] = []
    
    init(floor floorReference: CGPoint, buildings: [Building]) {
        self.floorReference = floorReference
        self.buildings = buildings
        place()
    }
    
    func place()
    {
        var reference : CGPoint = floorReference
        for build in buildings
        {
            build.position = reference
            reference.x = reference.x + build.size.width
        }
    }
    
    func removeBuildings() -> Void
    {
        for build in buildings {
            build.removeFromParent()
        }
    }
    
    func addBuildings(to scene: SKScene) -> Void {
        for build in buildings {
            scene.addChild(build)
        }
    }
    
}

class Building: SKSpriteNode
{
    var type : BuildingType!
    convenience init(name: String, position: CGPoint, type: BuildingType)
    {
        self.init(name: name, type: type)
        self.position = position
    }
    
    init(name: String, type: BuildingType) {
        let texture = SKTexture(imageNamed: type.rawValue)
        super.init(texture: texture, color: .white, size: texture.size())
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let reception = Building(name: "Recepcao", type: .RECEPTION)
        let stairs_0 = Building(name: "Stairs", type: .STAIRS)
        
        let floor = Floor(floor: CGPoint(x: 0, y: 0), buildings: [stairs_0, reception])
        
        let build = Building(name: "Teste", type: .STAIRS)
        let build2 = Building(name: "Teste3", type: .SIMPLE_ROOM)
        let build3 = Building(name: "Teste3", type: .SIMPLE_ROOM)
        
        let floor2 = Floor(floor: CGPoint(x: 0, y: 195), buildings: [build, build2, build3])
        
        floor.addBuildings(to: self)
        floor2.addBuildings(to: self)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

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
