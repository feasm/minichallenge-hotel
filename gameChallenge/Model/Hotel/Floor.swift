//
//  Floor.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 25/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit
import SpriteKit

class Floor
{
    private var floorReference : CGPoint!
    private var buildingsTypes : [BuildingType] = []
    private var buildings : [Building] = []
    var floorWidth : CGFloat = 0
    
    init(floor floorReference: CGPoint, buildings: [Building]) {
        self.floorReference = floorReference
        self.buildings = buildings
        place()
    }
    
    convenience init(floor: Int, buildings: [Building])
    {
        //let offset : CGFloat = (floor == 0) ? Hotel.FLOOR_OFFSET : 0
        let floorR = CGPoint(x: 0, y: Hotel.FLOOR_OFFSET+(CGFloat(floor) * Hotel.FLOOR_HEIGHT))
        self.init(floor: floorR, buildings: buildings)
    }
    
    func availableRooms() -> [Int]
    {
        var i = 1
        var rooms : [Int] = []
        for build in buildings
        {
            if build.type == .SIMPLE_ROOM
            {
                if !build.getAttribute(.OCCUPIED)
                {
                    rooms.append(i)
                }
                i += 1
            }
        }
        return rooms
    }
    
    func place(at reference: CGPoint)
    {
        var ref : CGPoint = reference
        floorWidth = 0
        
        for build in buildings
        {
            build.position = ref
            ref.x = ref.x + build.size.width
            floorWidth += build.size.width
        }
    }
    
    func getBuilding(at position: CGPoint) -> Building?
    {
        for build in buildings
        {
            if build.contains(position)
            {
                return build
            }
        }
        return nil
    }
    
    func getTeleporterPosition() -> CGPoint
    {
        for build in buildings where build.type == BuildingType.STAIRS
        {
            return build.position + CGPoint(x: build.size.width/2, y: 0)
        }
        return CGPoint(x: 0, y: 0)
    }
    
    func getRoomPosition(room: Int) -> CGPoint
    {
        var i : Int = 1
        for build in buildings
        {
            if build.type == .SIMPLE_ROOM
            {
                if i == room
                {
                    return (build.position + CGPoint(x: build.size.width/2, y: 0))
                }
                i += 1
            }
        }
        return CGPoint(x: 0, y: 0)
    }
    
    func getReceptionPosition() -> CGPoint
    {
        for buid in buildings where buid.type == BuildingType.RECEPTION
        {
            return buid.position + CGPoint(x: buid.size.width, y: 0)
        }
        return CGPoint(x: 0, y: 0)
    }
    
    func place()
    {
        self.place(at: floorReference)
    }
    
    func removeBuildings() -> Void
    {
        for build in buildings {
            build.removeFromParent()
        }
    }
    
    func availableActions(at point: CGPoint) -> [ActionTypes]
    {
        var actions : [ActionTypes] = []
        for build in buildings
        {
            if build.contains(point)
            {
                for action in build.getActions()
                {
                    actions.append(action)
                }
                
                switch build.type as BuildingType
                {
                    case .STAIRS:
                        actions.append(.USE_TELEPORTER)
                        fallthrough
                    case .RECEPTION:
                        if !GameModel.shared.receptionTaken {
                            actions.append(.ENTER_RECEPTION)
                        }
                        fallthrough
                    default:
                        actions.append(.WALK_TO)
                }
                break;
            }
        }
        return actions
    }
    
    func addBuildings(to scene: SKScene) -> Void {
        print("Andar construido em \(floorReference) - \(buildings.count) construções")
        for build in buildings {
            scene.addChild(build)
        }
    }
    
}

// MARK: BuildManager
extension Floor {
    func tryRemoveDirty(centerPoint: CGPoint) {
        for build in self.buildings {
            if build.position == centerPoint {
                build.removeAttribute(.DIRTY_FLOOR)
            }
        }
    }
}
