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
    @IBOutlet var background : UIImageView!
    @IBOutlet var logo : UIImageView!
    @IBOutlet var startButton : UIButton!
    
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
        startButton.layer.cornerRadius = 5
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        startButton.layer.masksToBounds = true
        
        logo.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        logo.layer.cornerRadius = 25
        logo.layer.masksToBounds = true
        
        background.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        
    }
    
    //MARK: Helper Methods
    
    //MARK: Actions
    @IBAction func startAction() {
        performSegue(withIdentifier: "startIdentifier", sender: nil)
    }


}

