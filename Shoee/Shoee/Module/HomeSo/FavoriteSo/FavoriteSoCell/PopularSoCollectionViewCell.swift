//
//  FavoriteSoCollectionViewCell.swift
//  Shoee
//
//  Created by Phincon on 05/12/23.
//

import UIKit

class PopularSoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var popularImage: UIImageView!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var titleCategoryProduct: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 15
    }

    func configure(name: String?, price: String?, imageURL: String?, category: String?) {
        productName.text = name
        priceText.text = price
        titleCategoryProduct.text = category

        if let url = URL(string: imageURL ?? "") {
            popularImage.kf.setImage(with: url)
        } else {
            // Handle the case where imageURL is not a valid URL
            popularImage.image = nil
        }
    }
}
