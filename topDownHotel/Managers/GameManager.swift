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
    static let shared = GameManager()
    static let DEBUG : Bool = false
    static let MULTIPLAYER_ON : Bool = true
    let directionalPad : DPad = DPad()
    var isHost: Bool = false
    
    // MARK: - Private
    private weak var scene: SKScene?
    {
        didSet {
            if let gameScene = scene as? GameScene {
                self.gameScene = gameScene
            }
            else {
                self.gameScene = nil
            }
        }
    }
    
    private(set) weak var gameScene : GameScene?
    
    private(set) var player : Player!
    private(set) var tileMap : SKTileMapNode?
    private(set) var guests : [Guest] = []
    private(set) var buildings : [Building] = []
    private(set) var rooms : [Room] = []
    
    private init() {
        BuildManager.shared.delegate = self
    }
    
    // MARK: - Public
    var players = [Player]()

    func configureFor(scene: SKScene) {
        self.scene = scene
        player = Player(position: .zero)
        addEntity(entity: player)
        
        directionalPad.showPad()
        
        //Building
        BuildManager.shared.buildRooms()
        
        if let scene = scene as? GameScene
        {
            tileMap = scene.backgroundTileMap
        }
    }
    
    func updateWithDeltaTime(seconds: CFTimeInterval) {
        player.update(deltaTime: seconds)
        
        for remotePlayer in players
        {
            remotePlayer.update(deltaTime: seconds)
        }
        
        for guest in guests
        {
            guest.update(deltaTime: seconds)
        }
    }
    
    // MARK: - Private
    
    private func addEntity(entity: GKEntity) {
        switch entity {
            case is Player:
                if player == nil {
                    player = entity as! Player
                } else {
                    players.append(entity as! Player)
                }
            
            case is Guest: guests.append(entity as! Guest)
            //case is Building : buildings.append(entity as! Building)
            case is Room : rooms.append(entity as! Room)
            default: break
        }
        
        if let vc = entity.component(ofType: VisualComponent.self) {
            scene?.addChild(vc.sprite)
            if entity is Player
            {
                if let scene = scene as? GameScene
                {
                    if entity as? Player == player {
                        scene.cameraTarget = vc.sprite
                    }
                }
            }
        }
    }
}

//MARK -> Entities Delegates

extension GameManager : BuildManagerDelegate
{
    func addBuild(_ build: Building) {
        addEntity(entity: build)
    }
}

//MARK -> Players methods
extension GameManager {
    func addPlayer(player: Player) {
        addEntity(entity: player)
    }
    
    func findPlayer(name: String) -> Player? {
        if player.name == name
        {
            return self.player
        }
        
        for player in players {
            if player.name == name {
                return player
            }
        }
        
        return nil
    }
}

//MARK -> Guests methods

extension GameManager
{
    func spawnGuest(at position : CGPoint, type: GuestType) -> Guest
    {
        let guest = Guest(position: position, type: type)
        addEntity(entity: guest)
        return guest
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
            let currentTile = BuildManager.tilePosition(position: position, tileMap: scene.backgroundTileMap)
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
                let action = SKAction.move(to: center, duration: TimeInterval(1/speed+1))
                actions.append(action)
            }
            return actions
        }
        return []
    }
    
    private func buildAPath(from: CGPoint, to: CGPoint) -> [GKGridGraphNode]
    {
        guard let tileMap = tileMap, let scene = self.scene as? GameScene else { return [] }

        let graph = scene.graph //scene.walkGraph
        
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

    func sendToRoom(guest : Guest, to: Int)
    {
        let room = rooms[to]
        let position = BuildManager.tilePosition(tile: room.entranceTile)
        guest.target = Target(position: position, room: to)
        guest.stateMachine?.enter(PathState.self)
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

// MARK: Multiplayer
extension GameManager {
    func movePlayer(name: String, target: Target?, position: CGPoint) {
        if let player = self.findPlayer(name: name) {
            if target != nil {
                player.moveToTarget(target: target!)
            } else {
                player.stateMachine?.enter(IdleState.self)
            }
        }
    }
}
