//
//  Hotel.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 25/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit
import SpriteKit

class Hotel {
    var hotelName : String!
    var floors : [Int : Floor] = [:]
    
    static let FLOOR_HEIGHT: CGFloat = 955
    static let FLOOR_OFFSET : CGFloat = 80
    
    init(name: String) {
        self.hotelName = name
    }
    
    func addFloor(floor: Floor, floorID: Int) -> Void {
        floors[floorID] = floor
    }
    
    func buildHotel(to scene: SKScene) {
        print("Andares adicionados: \(floors.count)")
        for (_, floor) in floors
        {
            floor.addBuildings(to: scene)
        }
    }
}
