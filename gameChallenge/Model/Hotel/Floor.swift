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
    
    func getTeleporterPosition() -> CGPoint
    {
        for buid in buildings where buid.type == BuildingType.STAIRS
        {
            return buid.position + CGPoint(x: buid.size.width/2, y: 0)
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
                switch build.type as BuildingType
                {
                    case .STAIRS:
                        actions.append(.USE_TELEPORTER)
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
