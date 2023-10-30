//
//  TableViewCell.swift
//  StoryBoardSwiftP1
//
//  Created by Phincon on 30/10/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    var collectionViewInTableViewViewController = CollectionViewInTableViewViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.CollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        
        self.CollectionView.delegate = self
        self.CollectionView.dataSource =  self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewInTableViewViewController.dataMovie[CollectionView.tag].Movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.images.image = UIImage(named: collectionViewInTableViewViewController.dataMovie[CollectionView.tag].Movies[indexPath.row])
        
        return cell
    }
}
