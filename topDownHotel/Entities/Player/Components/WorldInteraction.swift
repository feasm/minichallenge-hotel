//
//  WorldInteraction.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 14/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import GameplayKit


class WorldInteraction : GKComponent
{
    private(set) var components : [WIType] = []
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func performInteraction()
    {
        if let entity = self.entity
        {
            for component in entity.components
            {
                if let comp = component as? WITypeComponent
                {
                    comp.performInteraction()
                }
            }
        }
    }
    
    func addByType(_ type : WIType)
    {
        switch type {
        case .DIRTY_FLOOR:
            let comp = WIDirty()
            addInteraction(component: comp)
        default:
            return
        }
    }
    
    private func addInteraction(component : WITypeComponent)
    {
        if !components.contains(component.type)
        {
            if let entity = self.entity
            {
                entity.addComponent(component)
                self.components.append(component.type)
            }
        }
    }
}
