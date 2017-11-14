//
//  WIDirty.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 14/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit

class WIDirty : WITypeComponent
{
    init()
    {
        super.init(type: .DIRTY_FLOOR)
    }
    
    override func performInteraction() {
        super.performInteraction()
//        if let scene = GameManager.sharedInstance.gameScene, let vc = entity?.component(ofType: VisualComponent.self)
//        {
//            if let tileMap = scene.worldInteractionTileMap
//            {
//                let tilePosition = BuildManager.tilePosition(position: vc.sprite.position)
//                guard let _ = tileMap.tileDefinition(atColumn: Int(tilePosition.x), row: Int(tilePosition.y))
//                else {
//                    //print("sujou")
//                    let tile = tileMap.tileSet.tileGroups.
//                    tileMap.setTileGroup(tile, forColumn: Int(tilePosition.x), row: Int(tilePosition.y))
//                    return
//                }
//                return
//            }
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
