//
//  PlayerData.swift
//  multipeerTeste
//
//  Created by Adonay Puszczynski on 20/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

class PlayerData
{
    var id : String!
    var name : String!
    var floor : Int!
    let separatorData : Character = "|"
    
    init(id: String, name : String, floor: Int) {
        self.id = id
        self.name = name
        self.floor = floor
    }
    
    init(data : Data) {
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
    }
}
