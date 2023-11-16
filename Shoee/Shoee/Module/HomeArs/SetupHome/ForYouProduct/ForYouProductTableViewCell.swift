//
//  ForYouProductTableViewCell.swift
//  Shoee
//
//  Created by Phincon on 15/11/23.
//

import UIKit

class ForYouProductTableViewCell: BaseTableCell {
    
    @IBOutlet weak var imageData: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
        imageData.layer.cornerRadius = 20
    }

    
    func configure(withTitle title: String?, andImageName imageName: String?) {
        titleLabel.text = title
        if let imageName = imageName {
            imageData.image = UIImage(named: imageName)
        } else {
            imageData.image = nil
        }
    }
}

