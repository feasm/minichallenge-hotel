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

    override func viewDidLoad() {
        super.viewDidLoad()
        if GameManager.MULTIPLAYER_ON {
            NotificationCenter.default.addObserver(self, selector: #selector(showAuthenticationViewController), name: GameKitHelper.PRESENT_AUTHENTICATION, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerAuthenticated), name: GameKitHelper.LOCAL_PLAYER_AUTHENTICATED, object: nil)
            
            GameKitHelper.shared.authenticateLocalPlayer()
        }
        
        if let scene = GKScene(fileNamed: "GameScene") {
            
            if let sceneNode = scene.rootNode as! GameScene? {
                
                sceneNode.scaleMode = .aspectFill
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    view.ignoresSiblingOrder = true
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.showsPhysics = true
                }
            }
        }
        
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
//        GameKitHelper.shared.findMatchWithMinPlayers(minPlayers: 3, maxPlayers: 4, viewController: self, delegate: self as! GameKitHelperDelegate)
    }
}
