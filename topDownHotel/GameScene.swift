//
//  GameScene.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 07/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var backgroundTileMap: SKTileMapNode!
    var obstaclesTileMap: SKTileMapNode!
    var foregroundTileMap : SKTileMapNode!
    var worldInteractionTileMap : SKTileMapNode!
    
    var spawnPosition : CGPoint!
    var cameraTarget : SKSpriteNode?
    {
        didSet
        {
            setupCamera()
        }
    }
    
    private var lastUpdateTime : TimeInterval = 0
    
    var graph : GKGridGraph<GKGridGraphNode>!
    var walkGraph : GKGridGraph<GKGridGraphNode>!
    
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        
        backgroundTileMap = childNode(withName: "background") as! SKTileMapNode
        obstaclesTileMap = childNode(withName: "obstacles") as! SKTileMapNode
        foregroundTileMap = childNode(withName: "foreground") as! SKTileMapNode
        worldInteractionTileMap = childNode(withName: "worldInteraction") as! SKTileMapNode
        let guestSpawn = childNode(withName: "guestSpawn") as! SKSpriteNode
        spawnPosition = guestSpawn.position
        
        GameManager.shared.configureFor(scene: self)
        
        GameManager.shared.spawnGuest(at: .zero)
        
        setupGridCollision()
        
        setupWalkGraph()
    }
    
    func validPosition(position: CGPoint) -> CGPoint
    {
        let col = Int(position.x).clamped(to: 0...backgroundTileMap.numberOfColumns)
        let rows = Int(position.y).clamped(to: 0...backgroundTileMap.numberOfRows)
        let pos = backgroundTileMap.centerOfTile(atColumn: col, row: rows)
        return pos
    }
    
    func setupWalkGraph()
    {
        guard let background = backgroundTileMap, let foreground = foregroundTileMap else{
            return
        }
        
        walkGraph = GKGridGraph(fromGridStartingAt: vector2(0, 0), width: Int32(background.numberOfColumns), height: Int32(background.numberOfRows), diagonalsAllowed: true)
        
        //let tiles = ["corridors"]
        let allowTiles = ["corridors_Center"]
        let additionalTiles = ["rug"]
        
        for row in 0..<background.numberOfRows
        {
            for column in 0..<background.numberOfColumns
            {
                guard let tile = background.tileDefinition(atColumn: column, row: row)
                else {
                    let obstacle = walkGraph.node(atGridPosition: vector2(Int32(column), Int32(row)))!
                    walkGraph.remove([obstacle])
                    continue
                }
                //let pieces = tile.name?.components(separatedBy: "_")
                //let prefix = pieces![0]
                if !allowTiles.contains(tile.name!)
                {
                    if let ftile = foreground.tileDefinition(atColumn: column, row: row)
                    {
                        let pieces = ftile.name?.components(separatedBy: "_")
                        let prefix = pieces![0]
                        if !additionalTiles.contains(prefix)
                        {
                            let obstacle = walkGraph.node(atGridPosition: vector2(Int32(column), Int32(row)))!
                            walkGraph.remove([obstacle])
                        }
                    }
                    else
                    {
                        let obstacle = walkGraph.node(atGridPosition: vector2(Int32(column), Int32(row)))!
                        walkGraph.remove([obstacle])
                    }
                }
            }
        }
        
        
        
        /*for row in 0..<foreground.numberOfRows
        {
            for column in 0..<foreground.numberOfColumns
            {
                guard
                else { continue }
                
                let pieces = tile.name?.components(separatedBy: "_")
                let prefix = pieces![0]
                if additionalTiles.contains(prefix)
                {
                    print(tile.name)
                    walkGraph.add([GKGridGraphNode(gridPosition: vector2(Int32(column), Int32(row)))])
                }
            }
        }*/
    }
    
    func setupGridCollision() {
        guard let obstacles = obstaclesTileMap else{
            return
        }
        graph = GKGridGraph(fromGridStartingAt: vector2(0, 0), width: Int32(obstacles.numberOfColumns), height: Int32(obstacles.numberOfRows), diagonalsAllowed: false)
        
        var physicsBody = [SKPhysicsBody]()
        
        for row in 0..<obstacles.numberOfRows
        {
            for column in 0..<obstacles.numberOfColumns
            {
                guard let tile = obstacles.tileDefinition(atColumn: column, row: row)
                    else { continue }
                
                let obstacle = graph.node(atGridPosition: vector2(Int32(column), Int32(row)))!
                graph.remove([obstacle])
                
                let center = obstacles.centerOfTile(atColumn: column, row: row)
                let body = SKPhysicsBody(rectangleOf: tile.size, center: center)
                physicsBody.append(body)
            }
        }
        
        obstacles.physicsBody = SKPhysicsBody(bodies: physicsBody)
        obstacles.physicsBody?.isDynamic = false
        obstacles.physicsBody?.friction = 0
    }
    
    func setupCamera(){
        guard let camera = camera, let target = cameraTarget else {
            return
        }
        
        let xRange = SKRange(lowerLimit: -backgroundTileMap.frame.size.width/2 + self.size.width/2, upperLimit: backgroundTileMap.frame.size.width/2 - self.size.width/2)
        let yRange = SKRange(lowerLimit: -backgroundTileMap.frame.size.height/2 + self.size.height/2, upperLimit: backgroundTileMap.frame.size.height/2 - self.size.height/2)
        
        let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        edgeConstraint.referenceNode = backgroundTileMap
        
        let zeroDistance = SKRange(constantValue: 0.0)
        camera.constraints = [SKConstraint.distance(zeroDistance, to: target), edgeConstraint]
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        //print(pos)
        /*if GameManager.shared.player.direction != .NONE
        {
            return
        }
        
        if pos.x > (camera?.position.x)!
        {
            if pos.y > (camera?.position.y)!
            {
                GameManager.shared.updateDirection(direction: .DOWN)
                //print(MovementDirection.DOWN.rawValue)
            }
            else
            {
                GameManager.shared.updateDirection(direction: .RIGHT)
                //print(MovementDirection.RIGHT.rawValue)
            }
        }
        else
        {
            if pos.y > (camera?.position.y)!
            {
                GameManager.shared.updateDirection(direction: .UP)
                //print(MovementDirection.UP.rawValue)
            }
            else
            {
                GameManager.shared.updateDirection(direction: .LEFT)
                //print(MovementDirection.LEFT.rawValue)
            }
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
        GameManager.shared.updateDirection(direction: .NONE)
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        GameManager.shared.updateDirection(direction: .NONE)
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        let dt = currentTime - self.lastUpdateTime
        self.lastUpdateTime = currentTime
        GameManager.shared.updateWithDeltaTime(seconds: dt)
    }
}

extension GameScene: GameKitHelperDelegate {
    func matchStarted() {
        
    }
    
    func matchEnded() {
        
    }
}

extension GameScene: GuestManagerDelegate {
    func spawnGuest() -> Guest {
        return GameManager.shared.spawnGuest(at: spawnPosition)
    }
    
    func sendActionData(messageType: MessageType) {
        
    }
}
