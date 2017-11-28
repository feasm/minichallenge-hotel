//
//  Minimap.swift
//  Corrida
//
//  Created by Adonay Puszczynski on 28/11/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import UIKit
import SpriteKit

class Minimap: NSObject
{
    var scene : SKScene!
    
    var background : SKSpriteNode!
    var nodes : [Player : SKSpriteNode?] = [:]
    
    init(scene: SKScene) {
        self.scene = scene
        
        super.init()
    }
    
    func configure(at position: CGPoint, scale: CGFloat)
    {
        let size = scene.size * scale
        configure(for: size, at: position)
    }
    
    func configure(for size: CGSize, at position: CGPoint)
    {
        if let camera = scene.camera
        {
            self.background = SKSpriteNode(color: .black, size: size)
            self.background.position = position
            self.background.color = UIColor.black.withAlphaComponent(0.45)
            self.background.zPosition = NodesZPosition.CONTROLLERS.rawValue
            camera.addChild(background)
        }
    }
    
    func update(players : [Player])
    {
        for player in players
        {
            if nodes[player] != nil
            {
                let node = (nodes[player])!
                if player.destroyed
                {
                    node?.removeFromParent()
                    nodes[player] = nil
                }
                else
                {
                    node?.position = nodePosition(at: player.position)
                }
            }
            else
            {
                if !player.destroyed
                {
                    if let node = mapNode(at: player.position, color: player.mainColor)
                    {
                        nodes[player] = node
                        background.addChild(node)
                    }
                }
            }
        }
    }
    
    func nodePosition(at position: CGPoint) -> CGPoint
    {
        if let scene = scene as? GameScene
        {
            let background = scene.background!
            let prop_x = (self.background.size.width - 20) / background.size.width
            let prop_y = (self.background.size.height - 20) / background.size.height
            let nodePosition = CGPoint(x: position.x * prop_x, y: position.y * prop_y)
            return nodePosition
        }
        return CGPoint(x: 0, y: 0)
    }
    
    func mapNode(at position: CGPoint, color : UIColor) -> SKSpriteNode?
    {
        let position = self.nodePosition(at: position)
        let node = SKSpriteNode(color: color, size: CGSize(width: 20, height: 20))
        node.zPosition = self.background.zPosition+1
        node.position = position
        return node
    }
}
