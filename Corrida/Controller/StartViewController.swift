//
//  ViewController.swift
//  storyWork
//
//  Created by Daniel Sant'Anna de Oliveira on 22/11/17.
//  Copyright © 2017 skynxx. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var logo : UIImageView!
    @IBOutlet var startButton : UIButton!
    @IBOutlet weak var logoFront: UIImageView!
    
    @IBOutlet weak var overlayer: UIView!
    //MARK: Variables

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
        UIView.animateKeyframes(withDuration: 2, delay: 0.5, options: [.repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.logoFront.transform = CGAffineTransform(translationX: 0, y: 22)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.logoFront.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }, completion: nil)

//        UIView.animateKeyframes(withDuration: 3, delay: 0.5, options: [.repeat], animations: {
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
//                self.logoFront.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//            })
//            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
//                self.logoFront.transform = CGAffineTransform(translationX: 0, y: 30)
//            })
//            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
//                self.logoFront.transform = CGAffineTransform(translationX: 0, y: 0)
//            })
//            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
//                self.logoFront.transform = CGAffineTransform(scaleX: 1, y: 1)
//            })
//        }, completion: nil)
    }
    
    //MARK: Helper Methods
    func matchStarted() {
        performSegue(withIdentifier: "startIdentifier", sender: nil)
    }
    
    func setLoading() {
        overlayer.isHidden = false
        let spinner = SpinnerView(frame: CGRect(x:self.view.bounds.midX-50, y:self.view.bounds.midY-50, width: 100, height:100))
        self.view.addSubview(spinner)
    }
    
    //MARK: Actions
    @IBAction func startAction() {
//        let modal = EndGameModal(players: players)
//        modal.show(animated: true)
        
//        let modal = AlertModal(message: "teste")
//        modal.show(animated: true)
        
        
        if GameManager.MULTIPLAYER_ON {
            NotificationCenter.default.addObserver(self, selector: #selector(showAuthenticationViewController), name: GameKitHelper.PRESENT_AUTHENTICATION, object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(playerAuthenticated), name: GameKitHelper.LOCAL_PLAYER_AUTHENTICATED, object: nil)

            GameKitHelper.shared.authenticateLocalPlayer()
        } else {
            self.present(GameViewController(), animated: true, completion: nil)
        }
    }
}

// MARK: Selectors
extension StartViewController {
    @objc func showAuthenticationViewController() {
        self.present(GameKitHelper.shared.authenticationViewController!, animated: true, completion: nil)
    }
    
    @objc func playerAuthenticated() {
        GameKitHelper.shared.findMatchWithMinPlayers(minPlayers: 2, maxPlayers: 2, viewController: self)
    }
}
