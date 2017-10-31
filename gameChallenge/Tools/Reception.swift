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
    func sendToRoom(guest: Guest, room: Int)
}

class ReceptionCell : UICollectionViewCell
{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Reception: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    let reuseIdentifier = "cellReception"
    var delegate : ReceptionDelegate?
    
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
            self.alpha = 1
        }
    }
    
    func hideReception()
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ReceptionCell
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //let cell = collectionView.cellForItem(at: indexPath) as! ReceptionCell
        self.hideReception()
    }
}
