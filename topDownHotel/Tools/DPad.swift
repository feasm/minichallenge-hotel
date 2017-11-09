//
//  DPad.swift
//  gameChallenge
//
//  Created by Daniel Sant'Anna de Oliveira on 07/11/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

class DPad: UIView {
    var upButton : UIButton!
    var leftButton : UIButton!
    var downButton : UIButton!
    var rightButton : UIButton!
    var middleView : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    
    func setupView(){
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupButtons(){
        upButton = UIButton()
        downButton = UIButton()
        leftButton = UIButton()
        rightButton = UIButton()
        middleView = UIImageView()
        
        addSubview(upButton)
        addSubview(leftButton)
        addSubview(downButton)
        addSubview(rightButton)
        addSubview(middleView)
        
        upButton.translatesAutoresizingMaskIntoConstraints = false
        upButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        upButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        upButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: (1/2.5)).isActive = true
        upButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: (1/2.5)).isActive = true
        
        downButton.translatesAutoresizingMaskIntoConstraints = false
        downButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        downButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        downButton.widthAnchor.constraint(equalTo: upButton.widthAnchor).isActive = true
        downButton.heightAnchor.constraint(equalTo: upButton.heightAnchor).isActive = true
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        leftButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        leftButton.widthAnchor.constraint(equalTo: upButton.widthAnchor).isActive = true
        leftButton.heightAnchor.constraint(equalTo: upButton.heightAnchor).isActive = true
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        rightButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightButton.widthAnchor.constraint(equalTo: upButton.widthAnchor).isActive = true
        rightButton.heightAnchor.constraint(equalTo: upButton.heightAnchor).isActive = true
        
        middleView.translatesAutoresizingMaskIntoConstraints = false
        middleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        middleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        middleView.widthAnchor.constraint(equalTo: upButton.widthAnchor).isActive = true
        middleView.heightAnchor.constraint(equalTo: upButton.heightAnchor).isActive = true
        
        upButton.setImage(UIImage(named: "dpad_arrow"), for: .normal)
        leftButton.setImage(UIImage(named: "dpad_arrow"), for: .normal)
        downButton.setImage(UIImage(named: "dpad_arrow"), for: .normal)
        rightButton.setImage(UIImage(named: "dpad_arrow"), for: .normal)
        middleView.image = UIImage(named: "dpad_middle")
        
        upButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        leftButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        downButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        upButton.addTarget(self, action: #selector(moveUp(_:)), for: .touchDown)
        leftButton.addTarget(self, action: #selector(moveLeft(_:)), for: .touchDown)
        downButton.addTarget(self, action: #selector(moveDown(_:)), for: .touchDown)
        rightButton.addTarget(self, action: #selector(moveRight(_:)), for: .touchDown)
        
        upButton.addTarget(self, action: #selector(releasePad(_:)), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(releasePad(_:)), for: .touchUpInside)
        downButton.addTarget(self, action: #selector(releasePad(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(releasePad(_:)), for: .touchUpInside)
       
        upButton.isUserInteractionEnabled = true
        downButton.isUserInteractionEnabled = true
        leftButton.isUserInteractionEnabled = true
        rightButton.isUserInteractionEnabled = true
    }
    
    func showPad() -> Void {
        self.alpha = 0
        UIView.animate(withDuration: 1) {
            self.alpha = 1
        }
    }
    
    func hidePad() -> Void {
        self.alpha = 1
        UIView.animate(withDuration: 1) {
            self.alpha = 0
        }
    }
    
    @objc func releasePad(_ sender: Any)
    {
        GameManager.sharedInstance.updateDirection(direction: .NONE)
    }
    
    //MARK: Actions
    @objc func moveUp(_ sender: Any) {
        GameManager.sharedInstance.updateDirection(direction: .UP)
    }
    
    @objc func moveLeft(_ sender: Any){
       GameManager.sharedInstance.updateDirection(direction: .LEFT)
    }
    
    @objc func moveDown(_ sender: Any){
        GameManager.sharedInstance.updateDirection(direction: .DOWN)
    }
    
    @objc func moveRight(_ sender: Any){
        GameManager.sharedInstance.updateDirection(direction: .RIGHT)
    }
}
