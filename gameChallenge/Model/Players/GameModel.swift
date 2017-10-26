//
//  GameModel.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 24/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

class GameModel
{
    static let shared : GameModel = GameModel()
    var players : [Player] = []
    var guests : [Guest] = []
    var hotel : Hotel!
    private init()
    {
        players.append(Player())
        loadHotel()
    }

    func loadHotel()
    {
        hotel = Hotel(name: "Hotel do fim do mundo")
        var buildings : [Building] = [Building(type: .STAIRS), Building(type: .RECEPTION), Building(type: .SIMPLE_ROOM)]
        hotel.addFloor(floor: Floor(floor: 0, buildings: buildings), floorID: 0)
        buildings = [Building(type: .STAIRS), Building(type: .SIMPLE_ROOM), Building(type: .SIMPLE_ROOM)]
        hotel.addFloor(floor: Floor(floor: 1, buildings: buildings), floorID: 1)
        buildings = [Building(type: .STAIRS), Building(type: .SIMPLE_ROOM), Building(type: .SIMPLE_ROOM)]
        hotel.addFloor(floor: Floor(floor: 1, buildings: buildings), floorID: 2)
    }
}
