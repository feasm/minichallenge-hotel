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
    static let DEBUG: Bool = false
    static let MULTIPLAYER_ON: Bool = false
    var players : [Player] = []
    var guests : [Guest] = []
    var hotel : Hotel!
    let teleporter : Teleporter = Teleporter()
    var isHost: Bool = false
    
    private init()
    {
        players.append(Player())
        loadHotel()
    }

    func loadHotel()
    {
        hotel = Hotel(name: "Hotel do fim do mundo")
        var buildings : [Building] = [Building(type: .STAIRS), Building(type: .SIMPLE_ROOM), Building(type: .RECEPTION)]
        hotel.addFloor(floor: Floor(floor: 0, buildings: buildings), floorID: 0)
        buildings = [Building(type: .STAIRS), Building(type: .SIMPLE_ROOM), Building(type: .SIMPLE_ROOM), Building(type: .SIMPLE_ROOM)]
        hotel.addFloor(floor: Floor(floor: 1, buildings: buildings), floorID: 1)
        buildings = [Building(type: .STAIRS), Building(type: .SIMPLE_ROOM), Building(type: .SIMPLE_ROOM), Building(type: .SIMPLE_ROOM)]
        hotel.addFloor(floor: Floor(floor: 2, buildings: buildings), floorID: 2)
    }
    
    func lookForGuest(node : GuestNode) -> Guest?
    {
        for guest in guests
        {
            if guest.guestNode == node
            {
                return guest
            }
        }
        return nil
    }
}
