//
//  FimiliarShoesCollectionViewCell.swift
//  Shoee
//
//  Created by Phincon on 16/11/23.
//

import UIKit

class FimiliarShoesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 15

    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

}
