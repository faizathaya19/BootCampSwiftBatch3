//
//  CollectionViewInTableViewCell.swift
//  StoryBoardSwiftP1
//
//  Created by Phincon on 30/10/23.
//

import UIKit

class CollectionViewInTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TableViewLayout: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
