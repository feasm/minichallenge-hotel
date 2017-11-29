//
//  GameViewController.swift
//  Corrida
//
//  Created by Felipe Melo on 11/22/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var hitList : Hitlist = Hitlist()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameView = SKView(frame: self.view.frame)
        gameView.ignoresSiblingOrder = false
        gameView.showsFPS = true
        gameView.showsNodeCount = true
        gameView.showsPhysics = true
        
        self.view.addSubview(gameView)
        
        if let scene = GKScene(fileNamed: "GameScene") {
            
            if let sceneNode = scene.rootNode as! GameScene? {
                sceneNode.hitlist = self.hitList
                sceneNode.scaleMode = .aspectFill
                gameView.presentScene(sceneNode)
            }
        }
        
        self.view.addSubview(hitList)
        hitList.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        hitList.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        hitList.widthAnchor.constraint(equalToConstant: 230).isActive = true
        hitList.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
//        hitList.addHit(hit: Hitkill(victim: Player(), reason: .HIT_MYSELF, killer: nil))
//        hitList.addHit(hit: Hitkill(victim: Player(), reason: .HIT_MYSELF, killer: nil))
//        hitList.addHit(hit: Hitkill(victim: Player(), reason: .HIT_MYSELF, killer: nil))
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
