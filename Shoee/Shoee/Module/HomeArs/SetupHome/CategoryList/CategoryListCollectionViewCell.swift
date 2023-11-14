//
//  CategoryListCollectionViewCell.swift
//  Shoee
//
//  Created by Phincon on 10/11/23.
//

import UIKit

class CategoryListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set corner radius
        self.viewContainer.layer.cornerRadius = 15
        
        // Add border
        self.viewContainer.layer.borderWidth = 1.0
        self.viewContainer.layer.borderColor = UIColor.gray.cgColor
    }
}
