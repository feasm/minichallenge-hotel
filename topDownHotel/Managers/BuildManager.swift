//
//  GameManager+Building.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 10/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit
import SpriteKit

//MARK -> Building Methods

protocol BuildManagerDelegate {
    func addBuild(_ build : Building)
}

class BuildManager {
    // MARK: - Constants
    static let TILE_SIZE : CGFloat = 96
    static let TILES_HORIZONTAL : Int = 50
    static let TILES_VERTICAL : Int = 50
    static let shared = BuildManager()
    
    // MARK: - Public
    var delegate : BuildManagerDelegate?
    var roomSize : CGSize = CGSize.zero
    
    var floor : [[SKSpriteNode?]] = []

    private init() {
        createFloor()
    }
 
    // MARK: - Public
    
    func buildRooms() {
        if let scene = GameManager.shared.gameScene
        {
            let directions : [String] = ["rug_Bottom", "rug_Top", "rug_Right", "rug_Left"]
            for direction in directions
            {
                for tile in getTilesBy(name: direction, scene.foregroundTileMap)
                {
                    let building = Room(tile: tile, direction: direction)
                    self.delegate?.addBuild(building)
                }
            }
        }
    }
    
    func getTilesBy(name : String, _ tileMap: SKTileMapNode?) -> [CGPoint] {
        guard let tileMap = tileMap else{
            return []
        }
        
        var positions : [CGPoint] = []
        
        for row in 0..<tileMap.numberOfRows {
            for column in 0..<tileMap.numberOfColumns {
                guard let tile = tileMap.tileDefinition(atColumn: column, row: row)
                    else { continue }
                if tile.name == name {
                    positions.append(CGPoint(x: column, y: row))
                    //positions.append(tilePosition(tile: CGPoint(x: column, y: row)))
                }
            }
        }
        
        return positions
    }
    
    func canMove(_ position: CGPoint) -> Bool
    {
        if let gameScene = GameManager.shared.gameScene
        {
            if let body = gameScene.physicsWorld.body(at: position)
            {
                if body.node?.name != nil
                {
                    return false
                }
            }
        }
        
        return true
        
    }
    
    func getRoomSize() -> CGSize
    {
        if roomSize == .zero
        {
            if let scene = GameManager.shared.gameScene
            {
                roomSize = scene.backgroundTileMap.mapSize
            }
        }
        return roomSize
    }
    
    // MARK: - Private
    
    private func createFloor()
    {
        for _ in 0..<BuildManager.TILES_VERTICAL
        {
            var dirty : [SKSpriteNode?] = []
            for _ in 0..<BuildManager.TILES_HORIZONTAL
            {
                dirty.append(nil)
            }
            floor.append(dirty)
        }
        
    }
    
    // MARK: - Static
    
    static func tilePosition(tile : CGPoint, tileMap : SKTileMapNode? = nil) -> CGPoint
    {
        if tileMap != nil {
            return (tileMap?.centerOfTile(atColumn: Int(tile.x), row: Int(tile.y)))!
        }
        else
        {
            if let scene = GameManager.shared.gameScene
            {
                return scene.backgroundTileMap.centerOfTile(atColumn: Int(tile.x), row: Int(tile.y))
            }
        }
        return CGPoint.zero
    }
    
    static func tilePosition(position: CGPoint, tileMap : SKTileMapNode? = nil) -> CGPoint
    {
        if tileMap != nil {
            let col = (tileMap?.tileColumnIndex(fromPosition: position))!
            let row = (tileMap?.tileRowIndex(fromPosition: position))!
            return CGPoint(x: col, y: row)
        }
        else
        {
            if let scene = GameManager.shared.gameScene
            {
                let col = scene.backgroundTileMap.tileColumnIndex(fromPosition: position)
                let row = scene.backgroundTileMap.tileRowIndex(fromPosition: position)
                return CGPoint(x: col, y: row)
            }
        }
        return CGPoint.zero
    }
}

