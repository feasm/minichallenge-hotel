//
//  Room.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 10/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit
import SpriteKit


class Room: Building {
    
    private(set) var entranceTile : CGPoint
    
    init(tile: CGPoint, direction: String) {
        self.entranceTile = tile
        super.init(position: BuildManager.tilePosition(tile: tile), type: .SIMPLE_ROOM)
        //let vc = VisualComponent(position: position, color: .red, size: CGSize(width: 96, height: 96))
        //vc.sprite.zPosition = 10
        let vc = VisualComponent(tile: tile, direction: direction)
        self.addComponent(vc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
