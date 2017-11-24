//
//  GameKitHelper.swift
//  GameCenterTest
//
//  Created by Felipe Melo on 10/24/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//
import UIKit
import GameKit

protocol GameKitHelperDelegate {
    func matchStarted()
    func matchEnded()
//    func performAction(playerName: String, state: PlayerState, target: Target)
}

class GameKitHelper: NSObject, GKMatchmakerViewControllerDelegate, GKMatchDelegate {
    
    // Constants
    static let shared: GameKitHelper = GameKitHelper()
    
    static let PRESENT_AUTHENTICATION = Notification.Name("present_authentication_view_controller")
    static let LOCAL_PLAYER_AUTHENTICATED = Notification.Name("local_player_authenticated")
    
    // Public
    var match: GKMatch?
    var gameScene: GameKitHelperDelegate?
    var startViewController: StartViewController?
    var prepareViewController: PrepareViewController?
    var chooseMapViewController: ChooseMapViewController?
    
    var authenticationViewController: UIViewController?
    var lastError: Error?
    
    // Private
    private(set) var _matchStarted: Bool?
    private(set) var enableGameCenter: Bool = false
    
    private(set) var playersDict: NSMutableDictionary?
    
    private override init() {
        super.init()
    }
    
    func debug() {
        
    }
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = { (vc, error) in
            self.lastError = error
            
            if vc != nil {
                self.setAuthenticationViewController(authenticationViewController: vc!)
            } else if localPlayer.isAuthenticated {
                self.enableGameCenter = true
                NotificationCenter.default.post(name: GameKitHelper.LOCAL_PLAYER_AUTHENTICATED, object: nil)
            } else {
                self.enableGameCenter = false
            }
        }
    }
    
    func setAuthenticationViewController(authenticationViewController: UIViewController?) {
        if authenticationViewController != nil {
            self.authenticationViewController = authenticationViewController
            
            let defaultCenter = NotificationCenter()
            NotificationCenter.default.post(name: GameKitHelper.PRESENT_AUTHENTICATION, object: defaultCenter)
        }
    }
    
    func setLastError(error: Error?) {
        self.lastError = error
        
        if let lastError = self.lastError {
            print(lastError)
        }
    }
}

// MARK -> Game methods
extension GameKitHelper {
    func findMatchWithMinPlayers(minPlayers: Int, maxPlayers: Int, viewController: UIViewController) {
        guard self.enableGameCenter else {
            return
        }
        
        self._matchStarted = false
        self.match = nil
        self.startViewController = viewController as? StartViewController
        viewController.dismiss(animated: true, completion: nil)
        
        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        
        if let mmvc = GKMatchmakerViewController(matchRequest: request) {
            mmvc.matchmakerDelegate = self
            
            viewController.present(mmvc, animated: true, completion: nil)
        }
    }
}

// MARK -> GKMatchmakerViewControllerDelegate
extension GameKitHelper {
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true, completion: nil)
        print("Error finding match: \(error.localizedDescription)")
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true, completion: nil)
        self.match = match
        match.delegate = self
        
        self.match?.chooseBestHostingPlayer(completionHandler: { (player) in
            if player?.alias == GKLocalPlayer.localPlayer().alias {
                print("Server em: \(player?.alias ?? "Erro ao pegar alias do host")")
                
                GameServer.shared.setup()
                
                self.startViewController?.matchStarted()
            } else {
                print("Cliente em: \(player?.alias ?? "Erro no alias do cliente")")
//                GameClient.shared.setup(gameScene: self.gameScene as! GuestManagerDelegate)
            }
        })
    }
}

// MARK -> GKMatchDelegate
extension GameKitHelper {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        guard self.match == match else {
            return
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            let jsonData = jsonString.data(using: .utf8)!
            let decoder = JSONDecoder()
            let gameData = try! decoder.decode(GameData.self, from: jsonData)
            
            switch gameData.messageType {
            case .GAME_BEGIN:
                GameClient.shared.setup(gameData.playerNames!)
            case .CHARACTER_CHANGED:
                prepareViewController?.changePlayerCharacter(player: PlayerEnum(rawValue: gameData.playerNumber!)!, character: gameData.character!)
            case .PLAYER_READY:
                print("ready message")
//                prepareViewController?.changePlayerReady()
            case .PLAYER_MESSAGE:
                print("player message")
//                GameManager.shared.movePlayer(name: gameData.name!, target: gameData.target, position: gameData.position!)
            case .GUEST_MESSAGE:
                print("guest message")
//                GuestManager.shared.updateGuest(guestIndex: gameData.guestIndex!, state: gameData.state!, target: gameData.target!)
            case .SPAWN_GUEST:
                print("spawn guest")
//                GuestManager.shared.spawnGuest()
            default:
                print("default message")
            }
        } else {
            print("not a valid UTF-8 sequence")
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        guard self.match == match else {
            return
        }
        
        switch(state) {
        case .stateConnected:
            print("Player connected!")
            
            if !self._matchStarted! && match.expectedPlayerCount == 0 {
                print("Ready to start a match!")
            }
            
        case .stateDisconnected:
            print("Player disconnected!")
            
            self._matchStarted = false
            self.gameScene?.matchEnded()
        case .stateUnknown:
            print("Unknow state!")
        }
    }
    
    func match(_ match: GKMatch, didFailWithError error: Error?) {
        guard self.match == match else {
            return
        }
        
        print("Match failed with error: \(error?.localizedDescription ?? "Erro")")
        self._matchStarted = false
        self.gameScene?.matchEnded()
    }
}

