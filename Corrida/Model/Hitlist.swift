//
//  Hitlist.swift
//  Corrida
//
//  Created by Adonay Puszczynski on 28/11/17.
//  Copyright © 2017 Felipe Melo. All rights reserved.
//

import UIKit


struct Hitkill : Equatable
{
    static func ==(lhs: Hitkill, rhs: Hitkill) -> Bool {
        return (lhs.killer == rhs.killer) && (lhs.reason == rhs.reason) && (lhs.victim == rhs.victim)
    }
    
    var victim : Player
    var reason : Player.DeathReason
    var killer : Player?
    
}

class HitCell : UICollectionViewCell
{
    var hitKill : Hitkill!
    var delegate : HitListDelegate?
    var indexPath : IndexPath!
    
    var reasonIcon : UIImageView =
    {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    var victimLabel : UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    var killerLabel : UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(victimLabel)
        victimLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        victimLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        victimLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.42).isActive = true
        victimLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(killerLabel)
        killerLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        killerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        killerLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.42).isActive = true
        killerLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(reasonIcon)
        reasonIcon.leftAnchor.constraint(equalTo: killerLabel.rightAnchor, constant: 5).isActive = true
        reasonIcon.rightAnchor.constraint(equalTo: victimLabel.leftAnchor, constant: -5).isActive = true
        reasonIcon.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(hit: Hitkill)
    {
        self.hitKill = hit
        
        victimLabel.text = self.hitKill.victim.alias
        victimLabel.textColor = self.hitKill.victim.mainColor
        
        if self.hitKill.killer != nil
        {
            killerLabel.text = self.hitKill.killer?.alias
            killerLabel.textColor = self.hitKill.killer?.mainColor
        }
        
        Timer.scheduledTimer(withTimeInterval: Hitlist.MAX_TIME_SCREEN, repeats: false) { (_) in
            self.delegate?.deleteAt(hit: self.hitKill)
        }
    }
}

protocol HitListDelegate
{
    func deleteAt(hit: Hitkill)
}

class Hitlist: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HitListDelegate
{
    let reuseIdentifier : String = "hitCell"
    
    let MAX_HITS_SCREEN : Int = 4
    static let MAX_TIME_SCREEN : TimeInterval = 10
    var hits : [Hitkill] = []
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
        self.register(HitCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HitCell
        {
            cell.configure(hit: hits[indexPath.row])
            cell.delegate = self
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 50)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hits.count
    }
    
    func deleteAt(hit: Hitkill)
    {
        visibleCells.forEach { (cell) in
            if let cell = cell as? HitCell
            {
                if cell.hitKill == hit
                {
                    if let index = hits.index(of: hit)
                    {
                        hits.remove(at: index)
                    }
                    
                    if let indexPath = self.indexPath(for: cell)
                    {
                        self.deleteItems(at: [indexPath])
                    }
                }
            }
        }
        
        //        print(hits.count, self.collectionView(self, numberOfItemsInSection: 0))
    }
    
    func addHit(hit: Hitkill)
    {
        if hits.count >= MAX_HITS_SCREEN
        {
            deleteAt(hit: hits.first!)
        }
        
        hits.append(hit)
        self.reloadData()
    }
}