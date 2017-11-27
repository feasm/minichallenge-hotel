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

    }
    
    //MARK: Helper Methods
    func matchStarted() {
        performSegue(withIdentifier: "startIdentifier", sender: nil)
    }
    
    //MARK: Actions
    @IBAction func startAction() {
        if GameManager.MULTIPLAYER_ON {
            NotificationCenter.default.addObserver(self, selector: #selector(showAuthenticationViewController), name: GameKitHelper.PRESENT_AUTHENTICATION, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerAuthenticated), name: GameKitHelper.LOCAL_PLAYER_AUTHENTICATED, object: nil)
            
            GameKitHelper.shared.authenticateLocalPlayer()
            
            overlayer.isHidden = false
            let spinner = SpinnerView(frame: CGRect(x:self.view.bounds.midX-50, y:self.view.bounds.midY-50, width: 100, height:100))
            self.view.addSubview(spinner)
        }
    }
}

// MARK: Selectors
extension StartViewController {
    @objc func showAuthenticationViewController() {
        self.present(GameKitHelper.shared.authenticationViewController!, animated: true, completion: nil)
    }
    
    @objc func playerAuthenticated() {
        GameKitHelper.shared.findMatchWithMinPlayers(minPlayers: 2, maxPlayers: 4, viewController: self)
    }
}
