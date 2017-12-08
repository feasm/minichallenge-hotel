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
    
    var endGameModal : EndGameModal = EndGameModal()
    let countDownLabel : UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 80)
        return label
    }()
    
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
                sceneNode.endGameModal = self.endGameModal
                sceneNode.countdownLabel = self.countDownLabel
                sceneNode.scaleMode = .aspectFill
                gameView.presentScene(sceneNode)
            }
        }
        
        self.view.addSubview(hitList)
        hitList.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        hitList.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        hitList.widthAnchor.constraint(equalToConstant: 300).isActive = true
        hitList.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        self.view.addSubview(endGameModal)
        endGameModal.translatesAutoresizingMaskIntoConstraints = false
        endGameModal.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        endGameModal.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        endGameModal.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        endGameModal.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0).isActive = true
        endGameModal.isHidden = true
      
        self.view.addSubview(countDownLabel)
        countDownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        countDownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
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
