//
//  GameViewController.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 18/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController {
    
    var actionSelector : FloatActionSelector!
    
    var gameView : SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if GameModel.MULTIPLAYER_ON {
            NotificationCenter.default.addObserver(self, selector: #selector(showAuthenticationViewController), name: GameKitHelper.PRESENT_AUTHENTICATION, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerAuthenticated), name: GameKitHelper.LOCAL_PLAYER_AUTHENTICATED, object: nil)
            
            GameKitHelper.shared.authenticateLocalPlayer()
        }
        
        actionSelector = FloatActionSelector(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)), icon: "", direction: .UP, actions: [])
        
        gameView =
        {
            let view = SKView(frame: self.view.frame)
            view.ignoresSiblingOrder = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
            return view
        }()
        
        view.addSubview(gameView)
        
        let scene = GameScene(fileNamed: "GameScene")!
        scene.scaleMode = .aspectFill
        scene.actionSelector = actionSelector
        scene.actionSelector?.delegate = scene
        gameView.presentScene(scene)
        view.addSubview(actionSelector)
        
        let teleporter = GameModel.shared.teleporter
        teleporter.frame = self.view.frame
        view.addSubview(teleporter)
    }
    
    @objc func showAuthenticationViewController() {
        self.present(GameKitHelper.shared.authenticationViewController!, animated: true, completion: nil)
    }
    
    @objc func playerAuthenticated() {
        GameKitHelper.shared.findMatchWithMinPlayers(minPlayers: 2, maxPlayers: 2, viewController: self, delegate: gameView.scene as! GameKitHelperDelegate)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: GameKitHelperDelegate {
    func performAction(playerName: String, state: PlayerState, target: Target) {
        
    }
    
    func movePlayer2(point: CGPoint) {
        
    }
    
    func matchStarted() {
        print("Match started!")
    }
    
    func matchEnded() {
        print("Match ended!")
    }
}
