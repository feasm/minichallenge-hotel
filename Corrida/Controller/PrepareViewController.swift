//
//  PrepareViewController.swift
//  storyWork
//
//  Created by Daniel Sant'Anna de Oliveira on 22/11/17.
//  Copyright © 2017 skynxx. All rights reserved.
//

import UIKit

enum CharactersEnum : Int, Codable {
    case FIRST = 1
    case SECOND = 2
    case THIRD = 3
    case FORTH = 4
}

enum PlayerEnum : Int, Codable {
    case FIRST = 1
    case SECOND = 2
    case THIRD = 3
}

enum PlayerStatusEnum : String, Codable {
    case READY = "READY"
    case NOT_READY = "NOT_READY"
}

class PrepareViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var background : UIImageView!
    @IBOutlet var playersView : UIView!
    @IBOutlet var charactersView : UIView!
    @IBOutlet var selectedView : UIView!
    @IBOutlet var readyButton : UIButton!
    
    //Players Outlets
    @IBOutlet var viewFirstPlayer : UIView!
    @IBOutlet var backgroundFirstPlayer : UIImageView!
    @IBOutlet var readyFirstPlayer : UILabel!
    @IBOutlet var nameFirstPlayer : UILabel!
    
    @IBOutlet var viewSecondPlayer : UIView!
    @IBOutlet var backgroundSecondPlayer : UIImageView!
    @IBOutlet var readySecondPlayer : UILabel!
    @IBOutlet var nameSecondPlayer : UILabel!
    
    @IBOutlet var viewThirdPlayer : UIView!
    @IBOutlet var backgroundThirdPlayer : UIImageView!
    @IBOutlet var readyThirdPlayer : UILabel!
    @IBOutlet var nameThirdPlayer : UILabel!
    
    //Characters Outlets
    @IBOutlet var viewFirstCharacter : UIView!
    @IBOutlet var backgroundFirstCharacter : UIImageView!
    
    @IBOutlet var viewSecondCharacter : UIView!
    @IBOutlet var backgroundSecondCharacter : UIImageView!
    
    @IBOutlet var viewThirdCharacter : UIView!
    @IBOutlet var backgroundThirdCharacter : UIImageView!
    
    @IBOutlet var viewFourthCharacter : UIView!
    @IBOutlet var backgroundFourthCharacter : UIImageView!
    
    //Selected Outlets
    @IBOutlet var imageSelectedCharacter : UIImageView!
    @IBOutlet var imageBaseSelected : UIImageView!
    
    //MARK: Variables
    
    var selectedCharacter : CharactersEnum? = nil
    var readyClicked : Bool = false

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
        GameKitHelper.shared.prepareViewController = self
        //TODO: SET BACKGROUND
        
        setupPlayers(firstName: "", secondName: "", thirdName:  "")
        setupCharacters()
        setupSelected()
    }
    
    func setupPlayers(firstName: String, secondName: String, thirdName: String) {
        
        //ROUND TOP-LEFT
        let pathTop = UIBezierPath(roundedRect:viewFirstPlayer.bounds,
                                   byRoundingCorners:[.topLeft],
                                   cornerRadii: CGSize(width: 20, height:  20))
        
        let maskLayerTop = CAShapeLayer()
        maskLayerTop.path = pathTop.cgPath
        
        //ROUND BOTTOM-LEFT
        let pathBottom = UIBezierPath(roundedRect:viewThirdPlayer.bounds,
                                      byRoundingCorners:[.bottomLeft],
                                      cornerRadii: CGSize(width: 20, height:  20))
        
        let maskLayerBottom = CAShapeLayer()
        maskLayerBottom.path = pathBottom.cgPath
        
        let pathNames = UIBezierPath(roundedRect:nameFirstPlayer.bounds,
                                      byRoundingCorners:[.topLeft, .bottomLeft],
                                      cornerRadii: CGSize(width: 20, height:  20))
        
        let maskNames = CAShapeLayer()
        maskNames.path = pathNames.cgPath
        
        //setup first player
        backgroundFirstPlayer.image = nil
        readyFirstPlayer.isHidden = true
        nameFirstPlayer.text = firstName
        nameFirstPlayer.layer.mask = maskNames
        nameFirstPlayer.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        backgroundFirstPlayer.layer.mask = maskLayerTop
        
        //setup second player
        backgroundSecondPlayer.image = nil
        readySecondPlayer.isHidden = true
        nameSecondPlayer.text = secondName
        nameSecondPlayer.layer.mask = maskNames
        nameSecondPlayer.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    
        //setup third player
        backgroundThirdPlayer.image = nil
        readyThirdPlayer.isHidden = true
        nameThirdPlayer.text = thirdName
        nameThirdPlayer.layer.mask = maskNames
        nameThirdPlayer.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        backgroundThirdPlayer.layer.mask = maskLayerBottom
    }
    
    func setupCharacters() {
        //TODO: SET BACKGROUND IMAGES
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectCharacter(_:)))
        
        charactersView.isUserInteractionEnabled = true
        charactersView.addGestureRecognizer(gesture)
        
        //setup first character
        backgroundFirstCharacter.isUserInteractionEnabled = false
        backgroundFirstCharacter.layer.cornerRadius = 5
        backgroundFirstCharacter.layer.borderWidth = 2
        backgroundFirstCharacter.layer.borderColor = UIColor.clear.cgColor
        backgroundFirstCharacter.layer.masksToBounds =  true
        
        //setup second character
        backgroundSecondCharacter.isUserInteractionEnabled = false
        backgroundSecondCharacter.layer.cornerRadius = 5
        backgroundSecondCharacter.layer.borderWidth = 2
        backgroundSecondCharacter.layer.borderColor = UIColor.clear.cgColor
        backgroundSecondCharacter.layer.masksToBounds =  true
        
        //setup third character
        backgroundThirdCharacter.isUserInteractionEnabled = false
        backgroundThirdCharacter.layer.cornerRadius = 5
        backgroundThirdCharacter.layer.borderWidth = 2
        backgroundThirdCharacter.layer.borderColor = UIColor.clear.cgColor
        backgroundThirdCharacter.layer.masksToBounds =  true
        
        //setup forth character
        backgroundFourthCharacter.isUserInteractionEnabled = false
        backgroundFourthCharacter.layer.cornerRadius = 5
        backgroundFourthCharacter.layer.borderWidth = 2
        backgroundFourthCharacter.layer.borderColor = UIColor.clear.cgColor
        backgroundFourthCharacter.layer.masksToBounds =  true
    }
    
    func setupSelected() {
        //TODO: SET IMAGES SELECTED CHARACTER
        
        if selectedCharacter != nil {
            switch selectedCharacter! {
            case .FIRST:
                imageSelectedCharacter.image = backgroundFirstCharacter.image
                
                backgroundFirstCharacter.layer.borderColor = #colorLiteral(red: 0.9960784314, green: 0.8156862745, blue: 0.04705882353, alpha: 1)
                backgroundSecondCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundThirdCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundFourthCharacter.layer.borderColor = UIColor.clear.cgColor
                break
            case .SECOND:
                imageSelectedCharacter.image = backgroundSecondCharacter.image
                
                backgroundFirstCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundSecondCharacter.layer.borderColor = #colorLiteral(red: 0.9960784314, green: 0.8156862745, blue: 0.04705882353, alpha: 1)
                backgroundThirdCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundFourthCharacter.layer.borderColor = UIColor.clear.cgColor
                break
            case .THIRD:
                imageSelectedCharacter.image = backgroundThirdCharacter.image
                
                backgroundFirstCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundSecondCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundThirdCharacter.layer.borderColor = #colorLiteral(red: 0.9960784314, green: 0.8156862745, blue: 0.04705882353, alpha: 1)
                backgroundFourthCharacter.layer.borderColor = UIColor.clear.cgColor
                break
            case .FORTH:
                imageSelectedCharacter.image = backgroundFourthCharacter.image
                
                backgroundFirstCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundSecondCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundThirdCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundFourthCharacter.layer.borderColor = #colorLiteral(red: 0.9960784314, green: 0.8156862745, blue: 0.04705882353, alpha: 1)
                break
            }
        } else {
            imageSelectedCharacter.image = nil
            
            backgroundFirstCharacter.layer.borderColor = UIColor.clear.cgColor
            backgroundSecondCharacter.layer.borderColor = UIColor.clear.cgColor
            backgroundThirdCharacter.layer.borderColor = UIColor.clear.cgColor
            backgroundFourthCharacter.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    //MARK: Helper Methods
    @objc func selectCharacter(_ sender : UITapGestureRecognizer) {
        guard !readyClicked else {
            return
        }
        
        let location = sender.location(in: charactersView)
        
        if viewFirstCharacter.frame.contains(location) {
            selectedCharacter = .FIRST
        } else if viewSecondCharacter.frame.contains(location) {
            selectedCharacter = .SECOND
        } else if viewThirdCharacter.frame.contains(location) {
            selectedCharacter = .THIRD
        } else if viewFourthCharacter.frame.contains(location) {
            selectedCharacter = .FORTH
        }
        
        //recebe data do gamecenter
        MultiplayerNetworking.shared.sendCharacterData(character: selectedCharacter!)
        
        setupSelected()
    }
    
    func changePlayerCharacter(player: PlayerEnum, character: CharactersEnum){
        
        //recebe player change character data
        var playerNum = player
        if player.rawValue > GameManager.shared.localNumber {
            playerNum = PlayerEnum(rawValue: player.rawValue - 1)!
        }
        
        switch playerNum {
        case .FIRST:
            switch character {
            case .FIRST:
                backgroundFirstPlayer.image = backgroundFirstCharacter.image
                break
            case .SECOND:
                backgroundFirstPlayer.image = backgroundSecondCharacter.image
                break
            case .THIRD:
                backgroundFirstPlayer.image = backgroundThirdCharacter.image
                break
            case .FORTH:
                backgroundFirstPlayer.image = backgroundFourthCharacter.image
                break
            }
            break
        case .SECOND:
            switch character {
            case .FIRST:
                backgroundSecondPlayer.image = backgroundFirstCharacter.image
                break
            case .SECOND:
                backgroundSecondPlayer.image = backgroundSecondCharacter.image
                break
            case .THIRD:
                backgroundSecondPlayer.image = backgroundThirdCharacter.image
                break
            case .FORTH:
                backgroundSecondPlayer.image = backgroundFourthCharacter.image
                break
            }
            break
        case .THIRD:
            switch character {
            case .FIRST:
                backgroundThirdPlayer.image = backgroundFirstCharacter.image
                break
            case .SECOND:
                backgroundThirdPlayer.image = backgroundSecondCharacter.image
                break
            case .THIRD:
                backgroundThirdPlayer.image = backgroundThirdCharacter.image
                break
            case .FORTH:
                backgroundThirdPlayer.image = backgroundFourthCharacter.image
                break
            }
            break
        }
    }
    
    func setReadyPlayer(player : PlayerEnum, status : PlayerStatusEnum) {
        //TODO: RECEBE PLAYER STATE
        var playerNum = player
        if player.rawValue > GameManager.shared.localNumber {
            playerNum = PlayerEnum(rawValue: player.rawValue - 1)!
        }
        
        switch playerNum {
        case .FIRST:
            switch status {
            case .READY:
                readyFirstPlayer.isHidden = false
                break
            case .NOT_READY:
                readyFirstPlayer.isHidden = true
                break
            }
            break
        case .SECOND:
            switch status {
            case .READY:
                readySecondPlayer.isHidden = false
                break
            case .NOT_READY:
                readySecondPlayer.isHidden = true
                break
            }
            break
        case .THIRD:
            switch status {
            case .READY:
                readyThirdPlayer.isHidden = false
                break
            case .NOT_READY:
                readyThirdPlayer.isHidden = true
                break
            }
            break
        }
    }
    
    //MARK: Actions
    @IBAction func readyAction() {
        //TODO: SEND PLAYER READY STATE
        
        if readyClicked {
            readyClicked = false
            readyButton.alpha = 1.0
        } else {
            readyClicked = true
            readyButton.alpha = 0.2
        }
        
        let playerStatus: PlayerStatusEnum = readyClicked ? .READY : .NOT_READY
        MultiplayerNetworking.shared.sendReady(playerStatus)
    }


}
