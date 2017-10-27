//
//  QueueManager.swift
//  gameChallenge
//
//  Created by Felipe Melo on 10/27/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit

class QueueManager {
    static let POSITION_OFFSET = 200
    
    var startPosition: CGPoint!
    private(set) var guests = [Guest]()
    
    init(startPosition: CGPoint) {
        self.startPosition = startPosition
    }
    
    func addGuest(guest: Guest) {
        moveToQueue(guest: guest)
    }
    
    func moveToQueue(guest: Guest) {
        let queuePosition = getCurrentQueuePosition()
        
        self.guests.append(guest)
        let moveToQueue = SKAction.walkTo(from: guest.guestNode!.position, to: queuePosition, speed: 2)
        
        guest.guestNode?.run(moveToQueue)
    }
    
    func getCurrentQueuePosition() -> CGPoint {
        let positionOffset = CGPoint(x: QueueManager.POSITION_OFFSET * self.guests.count, y: 0)
        
        return self.startPosition + positionOffset
    }
}
