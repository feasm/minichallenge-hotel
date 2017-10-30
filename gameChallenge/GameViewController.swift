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

class GameViewController: UIViewController {
    
    var actionSelector : FloatActionSelector!
    
    var gameView : SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionSelector = FloatActionSelector(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)), icon: "", direction: .UP, actions: [])
        
        gameView =
        {
            let view = SKView(frame: self.view.frame)
            view.ignoresSiblingOrder = false
            view.showsFPS = true
            view.showsNodeCount = true
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
