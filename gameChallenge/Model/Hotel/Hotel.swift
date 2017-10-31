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
    static let FLOOR_START : CGPoint = .zero
    
    init(name: String) {
        self.hotelName = name
    }
    
    func addFloor(floor: Floor, floorID: Int) -> Void {
        floors[floorID] = floor
    }
    
    func availableRoomsAtHotel() -> [Int : [Int]]
    {
        var rooms : [Int : [Int]] = [:]
        for (key, floor) in floors
        {
            if floor.availableRooms().count > 0
            {
                rooms[key] = floor.availableRooms()
            }
        }
        return rooms
    }
    
    
    
    func buildHotel(to scene: SKScene) {
        print("Andares adicionados: \(floors.count)")
        for (_, floor) in floors
        {
            floor.addBuildings(to: scene)
        }
    }
    
    func getMaxWidth() -> CGFloat
    {
        let heights = floors.values.map { $0.floorWidth }
        return heights.max() != nil ? heights.max()! : 0
    }
    
    func build(to scene: SKScene, floorID: Int)
    {
        if let floor = floors[floorID]
        {
            floor.place(at: Hotel.FLOOR_START)
            floor.addBuildings(to: scene)
        }
        
        if let floor = floors[floorID+1]
        {
            floor.place(at: Hotel.FLOOR_START+CGPoint(x: 0, y: Hotel.FLOOR_HEIGHT))
            floor.addBuildings(to: scene)
        }
        
    }
    
    func buildAndRemove(to scene: SKScene, floorID: Int)
    {
        for (_, floor) in floors
        {
            floor.removeBuildings()
        }
        build(to: scene, floorID: floorID)
    }
    
    func loadFloor(floorID: Int) -> Floor?
    {
        if let floor = floors[floorID]
        {
            return floor
        }
        return nil
    }
}
