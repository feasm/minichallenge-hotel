//
//  EndGameModal.swift
//  Corrida
//
//  Created by Daniel Sant'Anna de Oliveira on 28/11/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import Foundation
import UIKit

class EndGameModal: UIView, Modal, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variables
    var backgroundView = UIView()
    var dialogView = UIView()
    var tableView : UITableView!
    
    var players : [Player]!
    
    convenience init(players: [Player]){
        self.init(frame: UIScreen.main.bounds)
        self.players = players
        setup()
    }
    
    private override init(frame: CGRect){
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
        
        setTableView()
    }
    
    //Setup TableView
    func setTableView(){
        let dialogViewHeight = frame.height
        let dialogViewWidth = frame.width-64
        
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: dialogViewWidth, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.clear
        addSubview(dialogView)
        
        tableView = UITableView(frame: CGRect(x: 8, y: 32, width: dialogViewWidth, height: 264))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PlayerEndGameTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerEndGameTableViewCell")
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        dialogView.addSubview(tableView)
        
        let readyButton = UIButton(frame : CGRect(x: (dialogView.frame.width/2)-100, y: tableView.frame.height + 24, width: 200, height: 50))
        readyButton.setTitle("Ready", for: .normal)
        readyButton.setBackgroundImage(UIImage(named: "Button_Layout"), for: .normal)
        readyButton.addTarget(self, action: #selector(readyAction), for: .touchUpInside)
        dialogView.addSubview(readyButton)
    }

    //MARK: UITableView Delegate/DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Alguma coisa e tal
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerEndGameTableViewCell", for: indexPath) as! PlayerEndGameTableViewCell
        
        cell.setup(player: players[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
        },completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
    }
    
    //MARK: Actions
    
    @objc func readyAction(){
        print("READY ACTION CLICKED")
        
        //TODO: PEGAR INDEX DENTRO DE PLAYERS
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! PlayerEndGameTableViewCell
        cell.setReady()
        
        //TODO: Send data do gamecenter
    }
    
    func dismissSAMERDA(){
        dismiss(animated: true)
    }
    
}



