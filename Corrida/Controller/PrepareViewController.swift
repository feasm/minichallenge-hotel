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
    @IBOutlet var topConstraintSelectedCharacter: NSLayoutConstraint!
    
    //MARK: Variables
    
    var selectedCharacter : CharactersEnum? = nil
    var readyClicked : Bool = false
    
    var blockedCharacters = [Int]()

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
        animateSelectedCharacter()
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
        
        let maskFirstName = CAShapeLayer()
        maskFirstName.path = pathNames.cgPath
        
        let maskSecondName = CAShapeLayer()
        maskSecondName.path = pathNames.cgPath
        
        let maskThirdName = CAShapeLayer()
        maskThirdName.path = pathNames.cgPath
        
        //setup first player
        backgroundFirstPlayer.image = nil
        readyFirstPlayer.isHidden = true
        nameFirstPlayer.text = firstName
        nameFirstPlayer.layer.mask = maskFirstName
        nameFirstPlayer.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        backgroundFirstPlayer.layer.mask = maskLayerTop
        
        //setup second player
        backgroundSecondPlayer.image = nil
        readySecondPlayer.isHidden = true
        nameSecondPlayer.text = secondName
        nameSecondPlayer.layer.mask = maskSecondName
        nameSecondPlayer.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    
        //setup third player
        backgroundThirdPlayer.image = nil
        readyThirdPlayer.isHidden = true
        nameThirdPlayer.text = thirdName
        nameThirdPlayer.layer.mask = maskThirdName
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
                imageSelectedCharacter.image = UIImage(named: "doggalien")
                
                backgroundFirstCharacter.layer.borderColor = #colorLiteral(red: 0.9960784314, green: 0.8156862745, blue: 0.04705882353, alpha: 1)
                backgroundSecondCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundThirdCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundFourthCharacter.layer.borderColor = UIColor.clear.cgColor
                break
            case .SECOND:
                imageSelectedCharacter.image = UIImage(named: "birdalien")
                
                backgroundFirstCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundSecondCharacter.layer.borderColor = #colorLiteral(red: 0.9960784314, green: 0.8156862745, blue: 0.04705882353, alpha: 1)
                backgroundThirdCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundFourthCharacter.layer.borderColor = UIColor.clear.cgColor
                break
            case .THIRD:
                imageSelectedCharacter.image = UIImage(named: "gooalien")
                
                backgroundFirstCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundSecondCharacter.layer.borderColor = UIColor.clear.cgColor
                backgroundThirdCharacter.layer.borderColor = #colorLiteral(red: 0.9960784314, green: 0.8156862745, blue: 0.04705882353, alpha: 1)
                backgroundFourthCharacter.layer.borderColor = UIColor.clear.cgColor
                break
            case .FORTH:
                imageSelectedCharacter.image = UIImage(named: "demalien")
                
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
            if !blockedCharacters.contains(CharactersEnum.FIRST.rawValue) {
                selectedCharacter = .FIRST
            } else {
                return
            }
        } else if viewSecondCharacter.frame.contains(location) {
            if !blockedCharacters.contains(CharactersEnum.SECOND.rawValue) {
                selectedCharacter = .SECOND
            } else {
                return
            }
        } else if viewThirdCharacter.frame.contains(location) {
            if !blockedCharacters.contains(CharactersEnum.THIRD.rawValue) {
                selectedCharacter = .THIRD
                } else {
                    return
            }
        } else if viewFourthCharacter.frame.contains(location) {
            if !blockedCharacters.contains(CharactersEnum.FORTH.rawValue) {
                selectedCharacter = .FORTH
            } else {
                return
            }
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
    
    func setReadyPlayer(player : PlayerEnum, status : PlayerStatusEnum, character: CharactersEnum) {
        //TODO: RECEBE PLAYER STATE
        var playerNum = player
        if player.rawValue > GameManager.shared.localNumber {
            playerNum = PlayerEnum(rawValue: player.rawValue - 1)!
        }
        
        if blockedCharacters.contains(character.rawValue) {
            var index: Int
            for (i,item) in blockedCharacters.enumerated() {
                if item == character.rawValue {
                    index = i
                }
            }
            
            blockedCharacters.remove(at: index)
            
            switch character {
            case .FIRST:
                backgroundFirstCharacter.image = UIImage(named: "Eu")
                break
            case .SECOND:
                backgroundSecondCharacter.image = UIImage(named: "Stocco")
                break
            case .THIRD:
                backgroundThirdCharacter.image = UIImage(named: "Daniel")
                break
            case .FORTH:
                backgroundFourthCharacter.image = UIImage(named: "Adonay")
                break
            }
        } else {
            blockedCharacters.append(character.rawValue)
            
            switch character {
            case .FIRST:
                backgroundFirstCharacter.image = self.convertToGrayScale(image: self.backgroundFirstCharacter.image!)
                break
            case .SECOND:
                backgroundSecondCharacter.image = self.convertToGrayScale(image: self.backgroundSecondCharacter.image!)
                break
            case .THIRD:
                backgroundThirdCharacter.image = self.convertToGrayScale(image: self.backgroundThirdCharacter.image!)
                break
            case .FORTH:
                backgroundFourthCharacter.image = self.convertToGrayScale(image: self.backgroundFourthCharacter.image!)
                break
            }
        }
        
        switch playerNum {
        case .FIRST:
            switch status {
            case .READY:
                UIView.animate(withDuration: 0.8, delay: 0.0, options: [.curveEaseInOut, .autoreverse],
                               animations: { self.viewFirstPlayer.alpha = 0.0 },
                               completion: { _ in
                                
                                self.viewFirstPlayer.alpha = 1.0
                                self.readyFirstPlayer.isHidden = false
                                self.backgroundFirstPlayer.image = self.convertToGrayScale(image: self.backgroundFirstPlayer.image!)
                })
                break
            case .NOT_READY:
                readyFirstPlayer.isHidden = true
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
            }
            break
        case .SECOND:
            switch status {
            case .READY:
                UIView.animate(withDuration: 0.8, delay: 0.0, options: [.curveEaseInOut, .autoreverse],
                               animations: { self.viewSecondPlayer.alpha = 0.0 },
                               completion: { _ in
                                
                                self.viewSecondPlayer.alpha = 1.0
                                self.readySecondPlayer.isHidden = false
                                self.backgroundSecondPlayer.image = self.convertToGrayScale(image: self.backgroundSecondPlayer.image!)
                })
                break
            case .NOT_READY:
                readySecondPlayer.isHidden = true
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
            }
            break
        case .THIRD:
            switch status {
            case .READY:
                UIView.animate(withDuration: 0.8, delay: 0.0, options: [.curveEaseInOut, .autoreverse],
                               animations: { self.viewThirdPlayer.alpha = 0.0 },
                               completion: { _ in
                                
                                self.viewThirdPlayer.alpha = 1.0
                                self.readyThirdPlayer.isHidden = false
                                self.backgroundThirdPlayer.image = self.convertToGrayScale(image: self.backgroundThirdPlayer.image!)
                })
                break
            case .NOT_READY:
                readyThirdPlayer.isHidden = true
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
            break
        }
        
        tryStartGame()
    }
    
    func tryStartGame() {
        guard readyClicked,
            !readyFirstPlayer.isHidden,
            (!readySecondPlayer.isHidden || GameManager.shared.players.count <= 2),
            (!readyThirdPlayer.isHidden || GameManager.shared.players.count <= 3) else {
               return
        }
        
        performSegue(withIdentifier: "chooseMapIdentifier", sender: nil)
    }
    
    func convertToGrayScale(image: UIImage) -> UIImage {
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")
        currentFilter!.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!,from: output!.extent)
        return UIImage(cgImage: cgimg!)
    }
    
    func animateSelectedCharacter(){
        UIView.animate(withDuration: 1200, delay: 0, usingSpringWithDamping: 0.00, initialSpringVelocity: 0.0004, options: UIViewAnimationOptions(), animations: {
            self.topConstraintSelectedCharacter.constant -= 3
            self.imageSelectedCharacter.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func readyAction() {
        
        if readyClicked {
            readyClicked = false
            readyButton.alpha = 1.0
        } else {
            readyClicked = true
            readyButton.alpha = 0.2
        }
        
        let playerStatus: PlayerStatusEnum = readyClicked ? .READY : .NOT_READY
        MultiplayerNetworking.shared.sendReady(playerStatus)
        
        tryStartGame()
    }


}
