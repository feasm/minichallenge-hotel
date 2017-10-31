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
    case DIRTY_FLOOR = "ba_dirtyfloor"
    case DIRTY = "ba_dirty"
}

class Building: SKSpriteNode
{
    var type : BuildingType!
    var attributes : [BuildingAttributes] = []
    var attributesNodes : [BuildingAttributes : SKSpriteNode] = [:]
    var attributesActions : [BuildingAttributes : [ActionTypes]] = [:]
    var centerPoint : CGPoint!
    
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
        self.name = "building"
        
        centerPoint = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size, center: centerPoint)
        
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.friction = 0
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 3
        
        setActions()
    }
    
    func setActions()
    {
        attributesActions[.DIRTY_FLOOR] = [.CLEAN_FLOOR]
        attributesActions[.DIRTY] = [.CLEAN_ROOM]
    }
    
    func getActions() -> [ActionTypes]
    {
        var actions = [ActionTypes]()
        for attr in attributes
        {
            if let availableActions = attributesActions[attr]
            {
                for action in availableActions
                {
                    actions.append(action)
                }
            }
        }
        return actions
    }
    
    func setAttribute(_ attribute : BuildingAttributes)
    {
        if !attributes.contains(attribute)
        {
            attributes.append(attribute)
            updateAttributes()
        }
    }
    
    func removeAttribute(_ attribute : BuildingAttributes)
    {
        if attributes.contains(attribute)
        {
            let index = attributes.index(of: attribute)!
            attributes.remove(at: index)
            if let node = attributesNodes[attribute]
            {
                node.removeFromParent()
            }
            attributesNodes.removeValue(forKey: attribute)
        }
    }
    
    func updateAttributes()
    {
        let needsNode : [BuildingAttributes] = [.DIRTY_FLOOR]
        for attr in attributes
        {
            if needsNode.contains(attr)
            {
                if let node = attributesNodes[attr]
                {
                    node.alpha = 1
                }
                else
                {
                    let node = SKSpriteNode(texture: SKTexture(imageNamed: "sujeira"))
                    node.anchorPoint = CGPoint(x: 0.5, y: 0)
                    node.position = CGPoint(x: self.centerPoint.x, y: 150)
                    self.addChild(node)
                    attributesNodes[attr] = node
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
