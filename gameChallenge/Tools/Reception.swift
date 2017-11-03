//
//  Reception.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 31/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

protocol ReceptionDelegate
{
    func sendToRoom(floor: Int, room: Int)
}

class ReceptionCell : UICollectionViewCell
{
    var roomName : String = ""
    var room : (floor: Int, room: Int)?
    
    let roomText : UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.brown
        setupViews()
    }
    
    func setRoom(roomName: String, room: (floor: Int, room: Int))
    {
        self.room = room
        self.roomName = roomName
        self.roomText.text = roomName
    }
    
    func setupViews() {
        addSubview(roomText)
        roomText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        roomText.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Reception: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    let buttonSize = CGSize(width: 130, height: 50)
    let reuseIdentifier = "cellReception"
    var delegate : ReceptionDelegate?
    var selectedRoom: Int = -10
    
    var rooms : [String : (floor: Int, room: Int)] = [:]
    
    var collectionView : UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
        backgroundColor = .black
        setupViews()
        
        rooms["1"] = (floor: 0, room: 1)
        rooms["2"] = (floor: 1, room: 1)
        rooms["3"] = (floor: 1, room: 2)
        rooms["4"] = (floor: 1, room: 3)
        rooms["5"] = (floor: 2, room: 1)
        rooms["6"] = (floor: 2, room: 2)
        rooms["7"] = (floor: 2, room: 3)
        rooms["Sair"] = (floor: -1, room: -1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()
    {
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ReceptionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.red
        
        collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
    }
    
    func showReception()
    {
        self.bringSubview(toFront: self)
        if GameModel.DEBUG
        {
            print("Showing reception")
        }
        self.alpha = 0
        UIView.animate(withDuration: 1) {
            self.alpha = 0.5
        }
    }
    
    func hideReception()
    {
        self.alpha = 0.5
        UIView.animate(withDuration: 1) {
            self.alpha = 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return buttonSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ReceptionCell
        let value = Array(rooms.keys).sorted()[indexPath.item]
        cell.setRoom(roomName: value, room: rooms[value]!)
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as! ReceptionCell
        if cell.room != nil
        {
            if cell.roomName == "Sair" {
                self.hideReception()
            } else {
                self.delegate?.sendToRoom(floor: cell.room!.floor, room: cell.room!.room)
            }
        }
    }
}
