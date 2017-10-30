//
//  FloatActionSelector.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 24/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

enum FloatDirection : Int
{
    case UP = 0
    case LEFT = 1
    case DOWN = 2
    case RIGHT = 3
}

protocol FloatActionSelectorDelegate
{
    func selectAction(action : ActionTypes, player : Player?, broadcast: Bool)
}

class FloatActionSelector: UIButton, FloatButtonDelegate {
    
    var minAngle : CGFloat = -30
    var maxAngle : CGFloat = 210
    var actions : [ActionTypes] = []
    var direction : FloatDirection = .DOWN
    var range : CGFloat = 240
    var delegate : FloatActionSelectorDelegate?
    
    lazy var actionsButton : [FloatButton] = []
    var cancelButton : FloatButton!
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = frame.width/2
        addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        isUserInteractionEnabled = true
        isHidden = true
    }
    
    convenience init(frame: CGRect, icon: String, direction: FloatDirection, actions: [ActionTypes]) {
        self.init(frame: frame)
        backgroundColor = UIColor.white
        self.direction = direction
        setActions(actions: actions)
    }
    
    func setActions(actions: [ActionTypes])
    {
        self.actions = actions
        if self.actions.count > 0
        {
            let spacing = Int(abs(range-180)/2)
            minAngle = CGFloat((direction.rawValue * 90) - spacing )
            maxAngle = minAngle + range
            
            for subs in subviews
            {
                subs.removeFromSuperview()
            }
            actionsButton.removeAll()
            
            let divisions = range/CGFloat(self.actions.count+1)
            
            var currentAngle = minAngle
            let distance : Double = 80
            
            
            for action in actions
            {
                currentAngle += divisions
                let origin = CGPoint(x: CGFloat((distance * cos(Double(currentAngle) * Double.pi / 180))), y: CGFloat(-(distance * sin(Double(currentAngle) * Double.pi / 180)))) //+ self.frame.origin
                let center : CGPoint = .zero
                let bt = FloatButton(frame: CGRect(origin: center, size: self.frame.size), position: origin, angle: currentAngle, action: action)
                bt.backgroundColor = self.backgroundColor
                bt.delegate = self
                actionsButton.append(bt)
                self.addSubview(bt)
            }
            
            cancelButton = FloatButton(frame: CGRect(origin: .zero, size: self.frame.size), position: .zero, angle: 0, action: .NONE)
            cancelButton.backgroundColor = .white
            cancelButton.delegate = self
            self.addSubview(cancelButton)

        }
    }
    
    func show(at position: CGPoint)
    {
        self.isHidden = false
        //print("showing at \(position)")
        self.frame.origin = position
        performSelector()
    }
    
    func hide()
    {
        self.isHidden = true
        performSelector()
    }
    
    func performSelector()
    {
        for button in actionsButton
        {
            button.performFlatButton()
        }
    }
    
    func selectAction(action: ActionTypes, player: Player?, broadcast: Bool) {
        self.delegate?.selectAction(action: action, player: nil, broadcast: broadcast)
        hide()
    }
    
    @objc func handleAction()
    {
        if !self.isHidden
        {
            hide()
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for view in self.subviews {
            if view.isUserInteractionEnabled, view.point(inside: self.convert(point, to: view), with: event) {
                return true
            }
        }
        
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
