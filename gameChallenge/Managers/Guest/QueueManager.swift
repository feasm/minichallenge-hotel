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
    static let DEBUG = true
    
    init(startPosition: CGPoint) {
        self.startPosition = startPosition
    }
    
    // Public
    func addGuest(guest: Guest) {
        moveToQueue(guest: guest)
        
        if GameModel.DEBUG {
            print("Guest spawned")
        }
    }
    
    func sendToRoom() {
        let guest = self.removeFromQueue()
        self.readjustQueue()
        
        guest.target = Target(position: nil, floor: 1, room: 1)
        guest.setState(state: .GO_TO_FLOOR)
        
        /*// Este é um código de teste para testar a fila, deve ser substituído pelo código de enviar para o quarto.
        let moveOutQueue = SKAction.walkTo(from: guest.guestNode!.position, to: .zero, speed: 3)
        guest.guestNode?.run(moveOutQueue)*/
        
        if GameModel.DEBUG {
            print("Guest sent to room!")
        }
    }
    
    // Private
    private(set) var startPosition: CGPoint!
    private(set) var guests = [Guest]()
    
    private func moveToQueue(guest: Guest) {
        let queuePosition = getLastQueuePosition()
        
        self.guests.append(guest)
        let moveToQueue = SKAction.walkTo(from: guest.guestNode!.position, to: queuePosition, speed: 3)
        guest.guestNode?.run(moveToQueue)
        
        if GameModel.DEBUG {
            print("Moving new guest to queue...")
        }
    }
    
    private func readjustQueue() {
        for (index, guest) in self.guests.enumerated() {
            let newQueuePosition = self.startPosition + CGPoint(x: 200 * index, y: 0)
            
            let reajustPositionInQueue = SKAction.walkTo(from: guest.guestNode!.position, to: newQueuePosition, speed: 3)
            guest.guestNode?.run(reajustPositionInQueue)
        }
    }
    
    private func removeFromQueue() -> Guest {
        return self.guests.removeFirst()
    }
    
    private func getLastQueuePosition() -> CGPoint {
        let positionOffset = CGPoint(x: QueueManager.POSITION_OFFSET * self.guests.count, y: 0)
        
        return self.startPosition + positionOffset
    }
}
