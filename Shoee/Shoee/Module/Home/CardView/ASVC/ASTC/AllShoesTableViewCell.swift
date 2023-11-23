//
//  TableViewCell.swift
//  StoryBoardSwiftP1
//
//  Created by Phincon on 30/10/23.
//

import UIKit

class AllShoesTableViewCell: UITableViewCell {
    @IBOutlet weak var ASCV: UICollectionView!
    
    var aLLShoesViewController = ALLShoesViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.ASCV.register(UINib(nibName: "AllShoesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "allShoesCollectionViewCell")
        
        
        self.ASCV.delegate = self
        self.ASCV.dataSource =  self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension AllShoesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aLLShoesViewController.dataMovie[ASCV.tag].Movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ASCV.dequeueReusableCell(withReuseIdentifier: "allShoesCollectionViewCell", for: indexPath) as! AllShoesCollectionViewCell
        cell.images.image = UIImage(named: aLLShoesViewController.dataMovie[ASCV.tag].Movies[indexPath.row])
        
        return cell
    }
}
