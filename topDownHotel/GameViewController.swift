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
        
        let pad = GameManager.sharedInstance.directionalPad
        view.addSubview(pad)
        pad.widthAnchor.constraint(equalToConstant: 150).isActive = true
        pad.heightAnchor.constraint(equalToConstant: 150).isActive = true
        pad.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pad.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
