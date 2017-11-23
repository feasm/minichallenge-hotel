//
//  ChooseMapViewController.swift
//  storyWork
//
//  Created by Daniel Sant'Anna de Oliveira on 23/11/17.
//  Copyright © 2017 skynxx. All rights reserved.
//

import UIKit

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
    var currentPostion = 0
    
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
        setupButtons()
        setupMap()
        
        background.image = nil
    }
    
    func setupButtons(){
        readyButton.layer.cornerRadius = 5
        readyButton.layer.borderWidth = 2
        readyButton.layer.borderColor = #colorLiteral(red: 0.1505601427, green: 0.8847555052, blue: 0.4229805416, alpha: 1)
        readyButton.layer.masksToBounds = true
        
        nextButton.layer.cornerRadius = 25
        nextButton.layer.borderWidth = 2
        nextButton.layer.borderColor = #colorLiteral(red: 0.1505601427, green: 0.8847555052, blue: 0.4229805416, alpha: 1)
        nextButton.layer.masksToBounds = true
        
        previousButton.layer.cornerRadius = 25
        previousButton.layer.borderWidth = 2
        previousButton.layer.borderColor = #colorLiteral(red: 0.8847555052, green: 0.1994391783, blue: 0.1890848464, alpha: 1)
        previousButton.layer.masksToBounds = true
    }
    
    func setupMap(){
        mapImage.layer.cornerRadius = 50
        mapImage.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    }
    
    //MARK: Helper Methods
    
    func changeMap(change: Int) {
        let tempPos = currentPostion+change
        
        if tempPos < maps.count && tempPos >= 0 {
            currentPostion = tempPos
        } else if tempPos >= maps.count {
            currentPostion = 0
        } else {
            currentPostion = maps.count-1
        }
        
        //TODO: ARRUMAR ISSO AQUI
//        mapImage.image = UIImage(named: maps[currentPostion])
        
        switch currentPostion {
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
    
    //MARK: Actions
    
    @IBAction func previousAction(){
        changeMap(change: -1)
    }

    @IBAction func nextAction(){
        changeMap(change: 1)
    }
    
    @IBAction func readyAction(){
        print("PREPARE GAME SCENE")
    }

}
