//
//  GameManager.swift
//  Corrida
//
//  Created by Felipe Melo on 11/22/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameManager {
    static let shared: GameManager = GameManager()
    static let MULTIPLAYER_ON: Bool = false
    
    var teleporters : [Teleporter] = []
    
    var localPlayer: Player!
    var localNumber: Int!
    var playerNumberToWatch: Int = 0
    
    var players = [Player]()
    var isHost: Bool = false
    
    var gameView: GameViewController?
    
    var effects : [Effect] = []
    var loadedSounds : [String : AVAudioPlayer?] = [:]
    
    private init() {
        loadedSounds[Sounds.MENU.rawValue] = loadSound(soundName: Sounds.MENU.rawValue, repeating: true)
        loadedSounds[Sounds.ENGINE.rawValue] = loadSound(soundName: Sounds.ENGINE.rawValue, repeating: true)
    }
    
    func movePlayer(name: String, position: CGPoint, rotation: CGFloat) {
        for player in self.players {
            if player.alias == name {
                player.position = position
                player.setRotation(to: rotation)
                break
            }
        }
    }
    
    func destroyPlayer(name: String, reason: DeathReason, defeat: String?) {
        var playerDestroyed: Player?
        var defeatedBy: Player?
        
        for player in self.players {
            if player.alias == name {
                playerDestroyed = player
            } else if defeat != nil && defeat == player.alias {
                defeatedBy = player
            }
        }
        
        if let player = playerDestroyed {
            player.destroyPlayer(reason: reason, defeat: defeatedBy)
        }
    }
    
    func findPlayerBy(alias: String) -> Player?
    {
        for player in players
        {
            if player.alias == alias
            {
                return player
            }
        }
        
        return nil
    }
    
    // TODO: Implementar se o rastro ficar desinronizado
    func createPath() {
        
    }
    
    func findPlayerToWatch(offset: Int) -> Player? {
        var index = 0
        
        repeat {
            playerNumberToWatch += offset
            if playerNumberToWatch >= GameManager.shared.players.count {
                playerNumberToWatch = 0
            } else if playerNumberToWatch < 0 {
                playerNumberToWatch = GameManager.shared.players.count - 1
            }
            
            index += 1
            
            if index > GameManager.shared.players.count {
                return nil
            }
        } while(GameManager.shared.players[playerNumberToWatch].destroyed)
        
        return GameManager.shared.players[playerNumberToWatch]
    }
}

// MARK: GameView
extension GameManager {
    func createGameView(view: UIView) -> GameViewController {
        guard gameView == nil else {
            return gameView!
        }
        
        gameView = GameViewController()
        return gameView!
    }
    
    func destroyGameView() {
        guard gameView != nil else {
            print("gameView não instanciada, não pode ser removida")
            return
        }
        
        gameView!.dismiss(animated: true, completion: nil)
        gameView = nil
    }
    
    func getPlayersScore() -> [Player] {
        return GameManager.shared.players.sorted(by: { (player1, player2) -> Bool in
            let timePlayer1 = player1.getFullTime()
            
            let timePlayer2 = player2.getFullTime()
            
            if timePlayer1 == timePlayer2 {
                return player1.lives() > player2.lives()
            } else {
                return timePlayer1 > timePlayer2
            }
        })
    }
}

// MARK: Audio

enum Sounds : String
{
    case COUNTDOWN = "snd_bip_countdown"
    case COUNTDOWN_END = "snd_bip_countdown_end"
    case MENU = "snd_menu"
    case ENGINE = "snd_engine"
    case DESTROY = "snd_destroy"
}

extension GameManager
{
    
    func loadSound(soundName: String, repeating: Bool) -> AVAudioPlayer?
    {
        var avSound : AVAudioPlayer?

        if let musicURL = Bundle.main.url(forResource: soundName, withExtension: "wav") {
            do {
                avSound = try AVAudioPlayer(contentsOf: musicURL)
                avSound?.prepareToPlay()
            }
            catch {
                
            }
            avSound?.volume = 0.4
            avSound?.numberOfLoops = repeating ? -1 : 1
            return avSound
        }
        return nil
    }
    
    func playSound(sound : Sounds) -> Void {
        playSound(soundname: sound.rawValue)
    }
    
    func playSound(soundname : String)
    {
        if let sound = loadedSounds[soundname] as? AVAudioPlayer {
            if !sound.isPlaying {
                sound.play()
            }
        }
        else {
            let load = loadSound(soundName: soundname, repeating: false)
            if load != nil
            {
                loadedSounds[soundname] = load
                playSound(soundname: soundname)
            }
        }
    }
    
    func stopSound(sound : Sounds)
    {
        stopSound(soundname: sound.rawValue)
    }
    
    func stopSound(soundname : String)
    {
        if let sound = loadedSounds[soundname] as? AVAudioPlayer
        {
            if sound.isPlaying
            {
                sound.stop()
            }
        }
    }
    
    func playSoundEffect(sound: Sounds, scene: SKScene) -> Void
    {
        let action = SKAction.playSoundFileNamed(sound.rawValue + ".wav", waitForCompletion: false)
        scene.run(action)
    }
    
}

// MARK: Teleporters

extension GameManager
{
    func getTeleporter(from: Teleporter) -> CGPoint
    {
        var temp : [Teleporter] = []
        for t in teleporters where (t.teleporter == from.teleporter && t != from)
        {
            temp.append(t)
        }
        
        if temp.count > 0
        {
            let t = temp.chooseOne
            return t.position
        }
        else
        {
            return from.position
        }
    }
}
