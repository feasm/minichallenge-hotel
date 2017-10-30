//
//  Teleporter.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 30/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

protocol TeleporterDelegate
{
    func choseFloor(floor: Int)
}

class TeleporterCell : UICollectionViewCell
{
    var floorName : String = ""
    var floorID : Int?
    
    let floorText : UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = frame.size.height/2
        backgroundColor = UIColor.brown
        setupViews()
    }
    
    func setFloor(floorName: String, floorID: Int)
    {
        self.floorID = floorID
        self.floorName = floorName
        self.floorText.text = floorName
    }
    
    func setupViews() {
        addSubview(floorText)
        floorText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        floorText.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Teleporter : UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    let reuseIdentifier = "cellTeleporter"
    var delegate : TeleporterDelegate?
    var selectedFloor : Int = -10
    
    var floors : [String : Int] = [:]
    
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
        backgroundColor = .blue
        setupViews()
        
        floors["0"] = 0
        floors["1"] = 1
        floors["2"] = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()
    {
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TeleporterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.red
        collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: 165).isActive = true
        collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
    }
    
    func showTeleporter()
    {
        self.bringSubview(toFront: self)
        print("Showing teleporter")
        self.alpha = 0
        UIView.animate(withDuration: 1) {
            self.alpha = 1
        }
    }
    
    func hideTeleporter()
    {
        self.alpha = 1
        UIView.animate(withDuration: 1) {
            self.alpha = 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return floors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TeleporterCell
        let value = Array(floors.keys)[indexPath.item]
        cell.setFloor(floorName: value, floorID: floors[value]!)
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as! TeleporterCell
        if cell.floorID != nil
        {
            print(cell.floorID!)
            self.delegate?.choseFloor(floor: cell.floorID!)
        }
        self.hideTeleporter()
    }
}
