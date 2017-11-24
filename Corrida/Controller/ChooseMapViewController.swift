//
//  ChooseMapViewController.swift
//  storyWork
//
//  Created by Daniel Sant'Anna de Oliveira on 23/11/17.
//  Copyright © 2017 skynxx. All rights reserved.
//

import UIKit
import SpriteKit

class ChooseMapViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var background : UIImageView!
    @IBOutlet var mapImage : UIImageView!
    @IBOutlet var readyButton : UIButton!
    @IBOutlet var nextButton : UIButton!
    @IBOutlet var previousButton : UIButton!
    
    //MARK: Variables
    var maps = ["map1", "map2", "map3"]
    var currentPosition = 0
    
    //MARK: Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //MARK: Setup Methods
    
    func setup() {
        GameKitHelper.shared.chooseMapViewController = self
        
        setupMap()
        setupButtons()
        
        background.image = nil
    }
    
    func setupMap(){
        mapImage.layer.cornerRadius = 50
        mapImage.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    }
    
    func setupButtons() {
        if !GameManager.shared.isHost {
            readyButton.alpha = 0.2
            readyButton.isUserInteractionEnabled = false
            
            nextButton.alpha = 0.2
            nextButton.isUserInteractionEnabled = false
            
            previousButton.alpha = 0.2
            previousButton.isUserInteractionEnabled = false
        }
    }
    
    //MARK: Helper Methods
    
    func changeMap(change: Int) {
        let tempPos = currentPosition+change
        
        if tempPos < maps.count && tempPos >= 0 {
            currentPosition = tempPos
        } else if tempPos >= maps.count {
            currentPosition = 0
        } else {
            currentPosition = maps.count-1
        }
        
        setMap(currentPosition)
        
        MultiplayerNetworking.shared.sendChangeMap(currentPosition)
    }
    
    func setMap(_ currentPosition: Int) {
        //TODO: ARRUMAR ISSO AQUI
        //        mapImage.image = UIImage(named: maps[currentPosition])
        
        switch currentPosition {
        case 0:
            mapImage.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            break
        case 1:
            mapImage.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            break
        case 2:
            mapImage.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            break
        default:
            break
        }
    }
    
    func presentGameView() {
        let gameView = SKView(frame: self.view.frame)
        gameView.ignoresSiblingOrder = false
        gameView.showsFPS = true
        gameView.showsNodeCount = true
        gameView.showsPhysics = false
        
        self.view.addSubview(gameView)
        
        let scene = GameScene(fileNamed: "GameScene")!
        scene.scaleMode = .aspectFill
        gameView.presentScene(scene)
        
        //        let pad = GameManager.shared.directionalPad
        //        view.addSubview(pad)
        //        pad.widthAnchor.constraint(equalToConstant: 150).isActive = true
        //        pad.heightAnchor.constraint(equalToConstant: 150).isActive = true
        //        pad.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        //        pad.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    //MARK: Actions
    
    @IBAction func previousAction(){
        changeMap(change: -1)
    }

    @IBAction func nextAction(){
        changeMap(change: 1)
    }
    
    @IBAction func readyAction(){
        print("PREPARE GAME SCENE")
        
        presentGameView()
        MultiplayerNetworking.shared.sendMapBegin()
    }
}
