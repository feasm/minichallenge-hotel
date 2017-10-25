//
//  CommonData.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 24/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

import UIKit

class CommonData
{
    var id : String!
    var name : String!
    var floor : Int!
    var room : Int!
    var state : PlayerState!
    var stateMachine : StateMachine?
    let separatorData : Character = "|"
    
    init(id: String, name : String, floor: Int, room: Int) {
        self.id = id
        self.name = name
        self.floor = floor
        self.room = room
        self.state = PlayerState.WAITING_FOR_ACTION
    }
    
    /*init(data : Data) {
        let content = String(data: data, encoding: .utf8)!
        let pieces = content.split(separator: separatorData)
        
        //print(pieces)
        
        self.id = String(pieces[0])
        self.name = String(pieces[1])
        self.floor = Int(pieces[2])
    }
    
    func data() -> Data
    {
        //self.id + separatorData + String(self.floor) + String(separatorData) + self.name
        var str = String()
        
        str.append(self.id, terminator: String(separatorData))
        str.append(self.name, terminator: String(separatorData))
        str.append(String(self.floor), terminator: String(separatorData))
        
        //print(str)
        
        return str.data(using: .utf8)!
    }*/
}
