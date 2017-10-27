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
}

class GuestManager {
    // MARK: Managers
    private var queueManager: QueueManager!
    
    // MARK: Constants
    static let shared: GuestManager = GuestManager()
    static let MIN_SPAWN_TIMER: Double = 1
    static let MAX_SPAWN_TIMER: Double = 10
    static let DEBUG: Bool = true
    
    // MARK: GuestsProperties
    private var guests = [Guest]()
    private var maxGuestsSpawn = 0
    private var currentGuestsSpawn = 0
    
    // MARK: SpawnerProperties
    private var nextSpawnTimer: Double = 0
    private var spawnTimer: Timer?
    private var gameScene: GuestManagerDelegate?
    
    private init() {
        if GuestManager.DEBUG {
            
        }
    }
    
    func initQueueManager() {
        let currentFloor = GameModel.shared.hotel.loadFloor(floorID: GameModel.shared.players.first!.floor)!
        let receptionPosition = currentFloor.getReceptionPosition() - CGPoint(x: 1200, y: 0)
        
        self.queueManager = QueueManager(startPosition: receptionPosition)
    }
    
    func setup(gameScene: GuestManagerDelegate, maxGuestsSpawn: Int = 5) {
        initQueueManager()
        setupGuests()
        setupSpawner(gameScene: gameScene, maxGuestsSpawn: maxGuestsSpawn)
    }
    
    func update() {
        
    }
}

// MARK: GuestsMethods
extension GuestManager {
    private func setupGuests() {
        if GuestManager.DEBUG {
            print("Guests configured")
        }
    }
}

// MARK: SpawnerMethods
extension GuestManager {
    private func setupSpawner(gameScene: GuestManagerDelegate, maxGuestsSpawn: Int) {
        self.gameScene = gameScene
        self.maxGuestsSpawn = maxGuestsSpawn
        self.prepareNextSpawn()
        
        if GuestManager.DEBUG {
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
    
    
    
    @objc private func spawnGuest() {
        let guest = self.gameScene?.spawnGuest()
        self.guests.append(guest!)
        self.currentGuestsSpawn += 1
        
        self.queueManager.addGuest(guest: guest!)
        
        if self.currentGuestsSpawn == self.maxGuestsSpawn {
            self.stopSpawner()
        } else {
            self.prepareNextSpawn()
        }
        
        if GuestManager.DEBUG {
            print("Guest spawned: \(self.nextSpawnTimer) seconds delay")
        }
    }
}
