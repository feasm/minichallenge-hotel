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
    
    init(floor floorReference: CGPoint, buildings: [Building]) {
        self.floorReference = floorReference
        self.buildings = buildings
        place()
    }
    
    convenience init(floor: Int, buildings: [Building])
    {
        let offset : CGFloat = (floor == 0) ? Hotel.FLOOR_OFFSET : 0
        let floorR = CGPoint(x: 0, y: offset+(CGFloat(floor) * Hotel.FLOOR_HEIGHT))
        self.init(floor: floorR, buildings: buildings)
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
        print("Andar construido em \(floorReference) - \(buildings.count) construções")
        for build in buildings {
            scene.addChild(build)
        }
    }
    
}
