//
//  PlayerEndGameTableViewCell.swift
//  Corrida
//
//  Created by Daniel Sant'Anna de Oliveira on 28/11/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import UIKit

class PlayerEndGameTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var killsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var readyLabel: UILabel!
    
    //MARK: Variables
    var player: Player!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup(player: Player){
        self.player = player
        //TODO: SET AVATAR, ALIAS, KILLS, TIMER, AND BACKGROUND IF IS LOCALPLAYER
        
        positionLabel.text = "2"
        
        mainView.layer.cornerRadius = 5
        mainView.layer.borderWidth = 5
        mainView.layer.borderColor = UIColor.clear.cgColor
        mainView.layer.masksToBounds = true
        
//        if player.isMe() {
//            mainView.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.8156862745, blue: 0.04705882353, alpha: 0.5)
//        readyLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        } else {
//            mainView.backgroundColor = #colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 0.5)
//        }
        
        separatorView.layer.cornerRadius = 5
        separatorView.layer.masksToBounds = true
        
//        avatar.image = player.
        avatar.layer.cornerRadius = 10
        avatar.layer.borderWidth = 2
        avatar.layer.borderColor = #colorLiteral(red: 0.9960784314, green: 0.8156862745, blue: 0.04705882353, alpha: 1)
        avatar.layer.masksToBounds = true
        
        nameLabel.text = player.alias
        
        killsLabel.text = "99 mortes"
        timerLabel.text = "12:57"
    }
    
    func setReady(){
        if readyLabel.isHidden {
            readyLabel.isHidden = false
        } else {
            readyLabel.isHidden = true
        }
    }
    
}
