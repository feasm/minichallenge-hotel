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
    
    var actionButton : UIButton!
    
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
        isUserInteractionEnabled = true
    }
    
    func setupButtons() {
        upButton = UIButton()
        downButton = UIButton()
        leftButton = UIButton()
        rightButton = UIButton()
        
        actionButton = UIButton()
        
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
        middleView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: (1/3.325)).isActive = true
        middleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: (1/3.325)).isActive = true
        
        upButton.setImage(UIImage(named: "dpad_arrow"), for: .normal)
        leftButton.setImage(UIImage(named: "dpad_arrow"), for: .normal)
        downButton.setImage(UIImage(named: "dpad_arrow"), for: .normal)
        rightButton.setImage(UIImage(named: "dpad_arrow"), for: .normal)
        middleView.image = UIImage(named: "dpad_middle")
        
        upButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        leftButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        downButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
       
        upButton.isUserInteractionEnabled = false
        downButton.isUserInteractionEnabled = false
        leftButton.isUserInteractionEnabled = false
        rightButton.isUserInteractionEnabled = false
    
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
    
    //MARK: Touches
    
    func updatePadDirection(_ position : CGPoint)
    {
        //print(position)
        if upButton.frame.contains(position){
            GameManager.shared.updateDirection(direction: .UP)
            upButton.isHighlighted = true
            leftButton.isHighlighted = false
            downButton.isHighlighted = false
            rightButton.isHighlighted = false
        } else if leftButton.frame.contains(position) {
            GameManager.shared.updateDirection(direction: .LEFT)
            leftButton.isHighlighted = true
            upButton.isHighlighted = false
            downButton.isHighlighted = false
            rightButton.isHighlighted = false
        } else if downButton.frame.contains(position) {
            GameManager.shared.updateDirection(direction: .DOWN)
            downButton.isHighlighted = true
            upButton.isHighlighted = false
            leftButton.isHighlighted = false
            rightButton.isHighlighted = false
        } else if rightButton.frame.contains(position) {
            GameManager.shared.updateDirection(direction: .RIGHT)
            rightButton.isHighlighted = true
            upButton.isHighlighted = false
            leftButton.isHighlighted = false
            downButton.isHighlighted = false
        }
        else
        {
            GameManager.shared.updateDirection(direction: .NONE)
            upButton.isHighlighted = false
            leftButton.isHighlighted = false
            downButton.isHighlighted = false
            rightButton.isHighlighted = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
        //if let touch = touches.first {
            updatePadDirection(touch.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            updatePadDirection(touch.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        GameManager.shared.updateDirection(direction: .NONE)
        upButton.isHighlighted = false
        leftButton.isHighlighted = false
        downButton.isHighlighted = false
        rightButton.isHighlighted = false
    }
}
