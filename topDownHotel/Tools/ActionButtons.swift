////
////  ActionButtons.swift
////  gameChallenge
////
////  Created by Daniel Sant'Anna de Oliveira on 09/11/17.
////  Copyright © 2017 Adonay Puszczynski. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//protocol ActionSelectorDelegate {
//    func selectAction(action : ActionTypes, player : Player?, broadcast: Bool)
//}
//
//class ActionButtons : UIView {
//    private var changeButton : UIButton!
//    private var actionButton : UIButton!
//
////    private var delegate : ActionSelectorDelegate?
//
//    private var actions : [ActionTypes]?
//    private var currentAction: ActionTypes?
//    private var currentActionIndex = 0
//
//    private override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupButtons()
//    }
//
//    convenience init(frame: CGRect, actions: [ActionTypes]){ //, delegate: ActionSelectorDelegate
//        self.init(frame: frame)
////        self.delegate = delegate
//        updateActions(actions: actions)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    //MARK: Setup
//
//    func setupButtons(){
//        changeButton = UIButton()
//        actionButton = UIButton()
//
//        addSubview(changeButton)
//        addSubview(actionButton)
//
//        changeButton.translatesAutoresizingMaskIntoConstraints = false
//        changeButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        changeButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        changeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: (1/3.5)).isActive = true
//        changeButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: (1/3.5)).isActive = true
//
//        actionButton.translatesAutoresizingMaskIntoConstraints = false
//        actionButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        actionButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        actionButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: (1/2.5)).isActive = true
//        actionButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: (1/2.5)).isActive = true
//
//        changeButton.setBackgroundImage(#imageLiteral(resourceName: "button_item"), for: .normal)
//        actionButton.setImage(#imageLiteral(resourceName: "button"), for: .normal)
//
//        changeButton.addTarget(self, action: #selector(changeAction(_:)), for: .touchUpInside)
//        actionButton.addTarget(self, action: #selector(doAction(_:)), for: .touchUpInside)
//
//        changeButton.isUserInteractionEnabled = true
//        actionButton.isUserInteractionEnabled = true
//    }
//
//    //MARK: Helper Methods
//    func updateActions(actions : [ActionTypes]){
//        self.actions = actions
//
//        if actions.count > 0 {
//            changeButton.isEnabled = true
//            actionButton.isEnabled = true
//
//            if currentAction == nil || !actions.contains(currentAction!){
//                currentAction = actions[0]
//                currentActionIndex = 0
//            }
//
//        } else {
//            changeButton.isEnabled = false
//            actionButton.isEnabled = false
//
//            currentAction = nil
//        }
//    }
//
//    private func setAction(position : Int) {
//        currentAction = actions![position]
//        changeButton.setImage(UIImage(named: currentAction!.rawValue), for: .normal)
//    }
//
//    //MARK: Actions
//    @objc func doAction(_ sender: Any){
//        guard currentAction == nil else {
//            return
//        }
//
////        self.delegate?.selectAction(action: currentAction!, player: nil, broadcast: false)
//    }
//
//    //MARK: Actions
//    @objc func changeAction(_ sender: Any){
//        guard actions == nil else {
//            return
//        }
//
//        if currentActionIndex >= 0 && currentActionIndex < actions!.count {
//            if currentActionIndex+1 == actions!.count {
//                currentActionIndex = 0
//            } else {
//                currentActionIndex += 1
//            }
//        }
//
//        setAction(position: currentActionIndex)
//    }
//
//}

