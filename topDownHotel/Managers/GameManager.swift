//
//  Game.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 07/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameManager {
    // MARK: - Constants
    static let sharedInstance = GameManager()
    static let DEBUG : Bool = false
    let directionalPad : DPad = DPad()
    
    // MARK: - Private
    private weak var scene: SKScene?
    private(set) var player : Player!
    private(set) var tileMap : SKTileMapNode?
    private(set) var guests : [Guest] = []
    
    
    
    private init()
    {
        
    }
    
    // MARK: - Public

    func configureFor(scene: SKScene)
    {
        self.scene = scene
        player = Player(position: .zero)
        addEntity(entity: player)
        
        directionalPad.showPad()
        
        if let scene = scene as? GameScene
        {
            tileMap = scene.backgroundTileMap
        }
    }
    
    func updateWithDeltaTime(seconds: CFTimeInterval) {
        player.update(deltaTime: seconds)
    }
    
    // MARK: - Private
    
    private func addEntity(entity: GKEntity) {
        switch entity {
            case is Player: player = entity as! Player
            case is Guest: guests.append(entity as! Guest)
            default: break
        }
        
        if let vc = entity.component(ofType: VisualComponent.self) {
            scene?.addChild(vc.sprite)
            if entity is Player
            {
                if let scene = scene as? GameScene
                {
                    scene.cameraTarget = vc.sprite
                }
            }
        }
    }
}


//MARK -> Guests methods

extension GameManager
{
    func spawnGuest(at position : CGPoint)
    {
        let guest = Guest(position: position)
        addEntity(entity: guest)
    }
}

//MARK -> Movement methods

extension GameManager
{
    func updateDirection(direction: MovementDirection)
    {
        player.moveToDirection(direction: direction)
    }
    
    func movementPositionByTile(from position: CGPoint, tile: CGPoint) -> CGPoint {
        if let scene = scene as? GameScene
        {
            let currentTile = scene.tilePosition(position: position)
            let finalTile = currentTile + tile
            return scene.validPosition(position: finalTile)
        }
        return CGPoint.zero
    }
    
    func path(from: CGPoint, to: CGPoint, speed: CGFloat) -> [SKAction]
    {
        guard let tileMap = tileMap else { return [] }
            
        let path = buildAPath(from: from, to: to)
        if path.count > 0
        {
            var actions = [SKAction]()
            for node in path
            {
                let center = tileMap.centerOfTile(atColumn: Int(node.gridPosition.x), row: Int(node.gridPosition.y))
                let action = SKAction.move(to: center, duration: TimeInterval(speed/10.0))
                actions.append(action)
            }
            return actions
        }
        return []
    }
    
    private func buildAPath(from: CGPoint, to: CGPoint) -> [GKGridGraphNode]
    {
        guard let tileMap = tileMap, let scene = self.scene as? GameScene else { return [] }

        let graph = scene.graph
        
        let fromColumn = tileMap.tileColumnIndex(fromPosition: from)
        let fromRow = tileMap.tileRowIndex(fromPosition: from)
        
        guard let fromNode = graph?.node(atGridPosition: vector2(Int32(fromColumn), Int32(fromRow)))
            else { return [] }
        
        let toColumn = tileMap.tileColumnIndex(fromPosition: to)
        let toRow = tileMap.tileRowIndex(fromPosition: to)
        
        guard let toNode = graph?.node(atGridPosition: vector2(Int32(toColumn), Int32(toRow)))
            else { return []}
        
        let path = graph?.findPath(from: fromNode, to: toNode) as! [GKGridGraphNode]
        return path
    }
    
    /*func movementPosition(position: CGPoint, tile: CGPoint) -> CGPoint {
     if let scene = scene as? GameScene
     {
     let finalTile = position + tile
     return scene.validPosition(position: finalTile)
     }
     return CGPoint.zero
     }*/
}
