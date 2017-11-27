//
//  Spawner.swift
//  Corrida
//
//  Created by Adonay Puszczynski on 25/11/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import SpriteKit

class Spawner : SKSpriteNode
{
    @IBInspectable var spawner : Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let data = userData
        {
            if let spawner = data["spawner"] as? Int
            {
                self.spawner = spawner
            }
        }
    }
    
    func getSpawner() -> Int
    {
        return self.spawner
    }
    
    func location() -> CGPoint
    {
        return self.position
    }
    
    func angleTo(_ position: CGPoint, degrees : Bool = false) -> CGFloat
    {
        return self.position.angle(position, degrees: degrees)
    }
}
