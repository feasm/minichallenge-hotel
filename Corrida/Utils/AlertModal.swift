//
//  AlertModal.swift
//  Corrida
//
//  Created by Daniel Sant'Anna de Oliveira on 28/11/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import Foundation
import UIKit

class AlertModal: UIView, Modal {
    //MARK: Variables
    var backgroundView = UIView()
    var dialogView = UIView()
    
    var message : String!
    
    //MARK: Inits
    convenience init(message: String) {
        self.init(frame: UIScreen.main.bounds)
        self.message = message
        
        setup()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    func setup(){
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        addSubview(backgroundView)
        
        setMessage()
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
    }
    
    func setMessage(){
        let dialogViewWidth = frame.width/2
        
        let messageLabel = UILabel(frame: CGRect(x: 8, y: 8, width: dialogViewWidth, height: 30))
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        dialogView.addSubview(messageLabel)
        
        let dialogViewHeight = messageLabel.frame.height + 16
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: dialogViewWidth, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        dialogView.clipsToBounds = true
        addSubview(dialogView)
    }
    
    //MARK: Actions
    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }
}
