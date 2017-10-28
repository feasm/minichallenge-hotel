//
//  FloatButton.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 24/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

protocol FloatButtonDelegate
{
    func selectAction(action : ActionTypes)
}

class FloatButton: UIButton {
    
    var position : CGPoint!
    var action : ActionTypes!
    var delegate : FloatButtonDelegate?
    var hide : Bool = true
    
    convenience init(frame: CGRect, position: CGPoint, angle: CGFloat, action: ActionTypes) {
        self.init(frame: frame)
        self.position = position
        self.action = action
        self.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        /*let tap = UITapGestureRecognizer(target: self, action: #selector(handleAction))
        self.addGestureRecognizer(tap)*/
    }
    
    @objc func handleAction()
    {
        self.delegate?.selectAction(action: action)
    }
    
    func performFlatButton()
    {
        if hide
        {
            self.alpha = 0
            UIButton.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(translationX: self.position.x, y: self.position.y)
                self.alpha = 1
            }
        }
        else
        {
            self.alpha = 1
            UIButton.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(translationX: 0, y: 0)
                self.alpha = 0
            }
        }
        hide = !hide
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = frame.height/2
        self.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
