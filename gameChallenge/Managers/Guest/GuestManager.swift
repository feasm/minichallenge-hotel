//
//  File.swift
//  gameChallenge
//
//  Created by Felipe Melo on 10/27/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import SpriteKit

protocol GuestManagerDelegate {
    func spawnGuest() -> Guest
    func sendActionData(messageType: MessageType)
}

class GuestManager {
    // Managers
    var queueManager: QueueManager!
    
    // Constants
    static let shared: GuestManager = GuestManager()
    static let MIN_SPAWN_TIMER: Double = 5
    static let MAX_SPAWN_TIMER: Double = 15
    static let DEBUG: Bool = true
    
    // MARK: GuestsProperties
    var guests = [Guest]()
    private var maxGuestsSpawn = 0
    private var currentGuestsSpawn = 0
    
    // MARK: SpawnerProperties
    private var nextSpawnTimer: Double = 0
    private var spawnTimer: Timer?
    private var gameScene: GuestManagerDelegate?
    
    private init() {
        if GameModel.DEBUG {
            
        }
    }
    
    func initQueueManager() {
        let currentFloor = GameModel.shared.hotel.loadFloor(floorID: 0)!
        let receptionPosition = currentFloor.getReceptionPosition() - CGPoint(x: 1200, y: 0)
        
        self.queueManager = QueueManager(startPosition: receptionPosition)
    }
    
    func setupAsHost(gameScene: GuestManagerDelegate, maxGuestsSpawn: Int = 5) {
        self.gameScene = gameScene
        initQueueManager()
        setupGuests()
        setupSpawner(maxGuestsSpawn: maxGuestsSpawn)
    }
    
    func setupAsClient(gameScene: GuestManagerDelegate) {
        self.gameScene = gameScene
        initQueueManager()
    }
    
    func update() {
        
    }
}

// MARK: GuestsMethods
extension GuestManager {
    private func setupGuests() {
        if GameModel.DEBUG {
            print("Guests configured")
        }
    }
}

// MARK: SpawnerMethods
extension GuestManager {
    private func setupSpawner(maxGuestsSpawn: Int) {
        self.maxGuestsSpawn = maxGuestsSpawn
        self.prepareNextSpawn()
        
        // Configurado removedor de guests da fila para testes, remover após implementar o envio para o quarto
//        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(sendToRoom), userInfo: nil, repeats: true)
        
        if GameModel.DEBUG {
            print("Spawner configured")
        }
    }
    
    private func stopSpawner() {
        self.spawnTimer?.invalidate()
    }
    
    private func randomNextSpawnTimer() {
        let spawnTimer = GuestManager.MAX_SPAWN_TIMER - GuestManager.MIN_SPAWN_TIMER
        
        self.nextSpawnTimer = Double(arc4random_uniform(UInt32(spawnTimer))) + GuestManager.MIN_SPAWN_TIMER
    }
    
    private func prepareNextSpawn() {
        self.randomNextSpawnTimer()
        
        self.spawnTimer = Timer.scheduledTimer(timeInterval: self.nextSpawnTimer, target: self, selector: #selector(spawnGuest), userInfo: nil, repeats: false)
    }
    
    @objc func spawnGuest() {
        let newGuest = self.gameScene?.spawnGuest()
        newGuest?.index = self.guests.count
        self.guests.append(newGuest!)
        self.currentGuestsSpawn += 1
        
        self.queueManager.addGuest(guest: newGuest!)
        
        if GameModel.shared.isHost || !GameModel.MULTIPLAYER_ON {
            if self.currentGuestsSpawn == self.maxGuestsSpawn {
                self.stopSpawner()
            } else {
                self.prepareNextSpawn()
                if GameModel.MULTIPLAYER_ON {
                    self.gameScene?.sendActionData(messageType: .SPAWN_GUEST)
                }
            }
        }
        
        if GameModel.DEBUG {
            print("Guest spawned: \(self.nextSpawnTimer) seconds delay")
        }
    }
    
    @objc private func sendToRoom() {
        if queueManager.guests.count > 0 {
            queueManager.sendToRoom(floor: 1, room: 2)
        }
    }
    
    func updateGuest(guestIndex: Int, state: PlayerState, target: Target) {
        let guest = self.guests[guestIndex]
        
        guest.target = target
        guest.setState(state: state)
        
        if GameModel.shared.HP > 0 {
            let scene = gameScene as! GameScene
            let newScore = Int(scene.Score.text!)! + 100
            scene.Score.text = "\(newScore)"
        }
    }
}
