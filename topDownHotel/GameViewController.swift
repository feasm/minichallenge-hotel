//
//  GameViewController.swift
//  topDownHotel
//
//  Created by Adonay Puszczynski on 07/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var gameView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if GameManager.MULTIPLAYER_ON {
            NotificationCenter.default.addObserver(self, selector: #selector(showAuthenticationViewController), name: GameKitHelper.PRESENT_AUTHENTICATION, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerAuthenticated), name: GameKitHelper.LOCAL_PLAYER_AUTHENTICATED, object: nil)
            
            GameKitHelper.shared.authenticateLocalPlayer()
        }
        
        gameView =
            {
                let view = SKView(frame: self.view.frame)
                view.ignoresSiblingOrder = false
                view.showsFPS = true
                view.showsNodeCount = true
                view.showsPhysics = false
                return view
        }()
        
        view.addSubview(gameView)
        
        let scene = GameScene(fileNamed: "GameScene")!
        scene.scaleMode = .aspectFill
        gameView.presentScene(scene)
        
        let pad = GameManager.shared.directionalPad
        view.addSubview(pad)
        pad.widthAnchor.constraint(equalToConstant: 150).isActive = true
        pad.heightAnchor.constraint(equalToConstant: 150).isActive = true
        pad.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        pad.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscapeRight
        } else {
            return .landscapeLeft
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK : Selectors
extension GameViewController {
    @objc func showAuthenticationViewController() {
        self.present(GameKitHelper.shared.authenticationViewController!, animated: true, completion: nil)
    }
    
    @objc func playerAuthenticated() {
        GameKitHelper.shared.findMatchWithMinPlayers(minPlayers: 2, maxPlayers: 2, viewController: self, delegate: self.gameView.scene as! GameKitHelperDelegate)
    }
}
