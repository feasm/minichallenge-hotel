//
//  Building.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 25/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit
import UIKit

//600px largura 955px

enum BuildingType : String
{
    case SIMPLE_ROOM = "simple_room"
    case RECEPTION = "reception"
    case STAIRS = "stairs"
    case KITCHEN = "kitchen"
}

enum BuildingAttributes : String
{
    case FLOOR_DIRTY = "ba_floordirty"
    case DIRTY = "ba_dirty"
}

class Building: SKSpriteNode
{
    var type : BuildingType!
    var attributes : [BuildingAttributes] = []
    
    convenience init(name: String, position: CGPoint, type: BuildingType)
    {
        self.init(type: type)
        self.position = position
    }
    
    init(type: BuildingType) {
        //let texture = SKTexture(imageNamed: type.rawValue)
        //super.init(texture: texture, color: .white, size: texture.size())
        switch type {
            case .SIMPLE_ROOM:
                let texture = SKTexture(imageNamed: type.rawValue)
                super.init(texture: texture, color: .white, size: texture.size())
            case .STAIRS:
                super.init(texture: nil, color: .green, size: CGSize(width: 800, height: Hotel.FLOOR_HEIGHT))
            case .RECEPTION:
                super.init(texture: nil, color: .red, size: CGSize(width: 1600, height: Hotel.FLOOR_HEIGHT))
            default:
                super.init(texture: nil, color: .yellow, size: CGSize(width: 800, height: Hotel.FLOOR_HEIGHT))
        }
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.type = type
        let center = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size, center: center)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.collisionBitMask = 2
        self.physicsBody?.contactTestBitMask = 2
        self.physicsBody?.fieldBitMask = 1
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
