//
//  PrepareViewController.swift
//  storyWork
//
//  Created by Daniel Sant'Anna de Oliveira on 22/11/17.
//  Copyright © 2017 skynxx. All rights reserved.
//

import UIKit

enum CharactersEnum : Int {
    case FIRST = 1
    case SECOND = 2
    case THIRD = 3
    case FORTH = 4
}

enum PlayerEnum : Int {
    case FIRST = 1
    case SECOND = 2
    case THIRD = 3
}

enum PlayerStatusEnum : String {
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
    @IBOutlet var loadingFirstPlayer : UIActivityIndicatorView!
    
    @IBOutlet var viewSecondPlayer : UIView!
    @IBOutlet var backgroundSecondPlayer : UIImageView!
    @IBOutlet var readySecondPlayer : UILabel!
    @IBOutlet var loadingSecondPlayer : UIActivityIndicatorView!
    
    @IBOutlet var viewThirdPlayer : UIView!
    @IBOutlet var backgroundThirdPlayer : UIImageView!
    @IBOutlet var readyThirdPlayer : UILabel!
    @IBOutlet var loadingThirdPlayer : UIActivityIndicatorView!
    
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
        //TODO: SET BACKGROUND
        background.image = nil
        
        setupButton()
        setupPlayers()
        setupCharacters()
        setupSelected()
    }
    
    func setupButton() {
        readyButton.layer.cornerRadius = 5
        readyButton.layer.borderWidth = 2
        readyButton.layer.borderColor = #colorLiteral(red: 0.1505601427, green: 0.8847555052, blue: 0.4229805416, alpha: 1)
        readyButton.layer.masksToBounds = true
    }
    
    func setupPlayers() {
        
        //setup first player
        viewFirstPlayer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        backgroundFirstPlayer.image = nil
        readyFirstPlayer.isHidden = false
        loadingFirstPlayer.isHidden = false
        loadingFirstPlayer.startAnimating()
        
        //setup second player
        viewSecondPlayer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        backgroundSecondPlayer.image = nil
        readySecondPlayer.isHidden = false
        loadingSecondPlayer.isHidden = false
        loadingSecondPlayer.startAnimating()
        
        //setup third player
        viewThirdPlayer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        backgroundThirdPlayer.image = nil
        readyThirdPlayer.isHidden = false
        loadingThirdPlayer.isHidden = false
        loadingThirdPlayer.startAnimating()
    }
    
    func setupCharacters() {
        //TODO: SET BACKGROUND IMAGES
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectCharacter(_:)))
        
        charactersView.isUserInteractionEnabled = true
        charactersView.addGestureRecognizer(gesture)
        
        //setup first character
        backgroundFirstCharacter.isUserInteractionEnabled = false
        backgroundFirstCharacter.image = nil
        backgroundFirstCharacter.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        //setup second character
        backgroundSecondCharacter.isUserInteractionEnabled = false
        backgroundSecondCharacter.image = nil
        backgroundSecondCharacter.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        
        //setup third character
        backgroundThirdCharacter.isUserInteractionEnabled = false
        backgroundThirdCharacter.image = nil
        backgroundThirdCharacter.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        
        //setup forth character
        backgroundFourthCharacter.isUserInteractionEnabled = false
        backgroundFourthCharacter.image = nil
        backgroundFourthCharacter.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    }
    
    func setupSelected() {
        //TODO: SET IMAGES SELECTED CHARACTER AND BASE
        
        if selectedCharacter != nil {
            switch selectedCharacter! {
            case .FIRST:
                print("FIRST CHARACTER SELECTED")
                imageSelectedCharacter.image = nil
                break
            case .SECOND:
                print("SECOND CHARACTER SELECTED")
                imageSelectedCharacter.image = nil
                break
            case .THIRD:
                print("THIRD CHARACTER SELECTED")
                imageSelectedCharacter.image = nil
                break
            case .FORTH:
                print("FORTH CHARACTER SELECTED")
                imageSelectedCharacter.image = nil
                break
            }
        } else {
            imageSelectedCharacter.image = nil
            imageSelectedCharacter.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        }
        
        imageBaseSelected.image =  nil
        imageBaseSelected.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    //MARK: Helper Methods
    @objc func selectCharacter(_ sender : UITapGestureRecognizer){
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
        
        //TODO: SEND DATA DO GAMECENTER
        
        setupSelected()
    }
    
    func changePlayerCharacter(player: PlayerEnum, character: CharactersEnum){
        //TODO: SET CHARACTERS IMAGE
        
        //TODO: RECEBE PLAYER CHANGE CHARACTER
        
        switch player {
        case .FIRST:
            switch character {
            case .FIRST:
                backgroundFirstPlayer.image = nil
                break
            case .SECOND:
                backgroundFirstPlayer.image = nil
                break
            case .THIRD:
                backgroundFirstPlayer.image = nil
                break
            case .FORTH:
                backgroundFirstPlayer.image = nil
                break
            }
            break
        case .SECOND:
            switch character {
            case .FIRST:
                backgroundSecondPlayer.image = nil
                break
            case .SECOND:
                backgroundSecondPlayer.image = nil
                break
            case .THIRD:
                backgroundSecondPlayer.image = nil
                break
            case .FORTH:
                backgroundSecondPlayer.image = nil
                break
            }
            break
        case .THIRD:
            switch character {
            case .FIRST:
                backgroundThirdPlayer.image = nil
                break
            case .SECOND:
                backgroundThirdPlayer.image = nil
                break
            case .THIRD:
                backgroundThirdPlayer.image = nil
                break
            case .FORTH:
                backgroundThirdPlayer.image = nil
                break
            }
            break
        }
    }
    
    func setReadyPlayer(player : PlayerEnum, status : PlayerStatusEnum){
        //TODO: RECEBE PLAYER STATE
        switch player {
        case .FIRST:
            switch status {
            case .READY:
                loadingFirstPlayer.isHidden = true
                readyFirstPlayer.isHidden = false
                loadingFirstPlayer.stopAnimating()
                break
            case .NOT_READY:
                loadingFirstPlayer.isHidden = false
                readyFirstPlayer.isHidden = true
                loadingFirstPlayer.startAnimating()
                break
            }
            break
        case .SECOND:
            switch status {
            case .READY:
                loadingSecondPlayer.isHidden = true
                readySecondPlayer.isHidden = false
                loadingSecondPlayer.stopAnimating()
                break
            case .NOT_READY:
                loadingSecondPlayer.isHidden = false
                readySecondPlayer.isHidden = true
                loadingSecondPlayer.startAnimating()
                break
            }
            break
        case .THIRD:
            switch status {
            case .READY:
                loadingThirdPlayer.isHidden = true
                readyThirdPlayer.isHidden = false
                loadingThirdPlayer.stopAnimating()
                break
            case .NOT_READY:
                loadingThirdPlayer.isHidden = false
                readyThirdPlayer.isHidden = true
                loadingThirdPlayer.startAnimating()
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
            
            performSegue(withIdentifier: "chooseMapIdentifier", sender: nil)
        }
    }


}
