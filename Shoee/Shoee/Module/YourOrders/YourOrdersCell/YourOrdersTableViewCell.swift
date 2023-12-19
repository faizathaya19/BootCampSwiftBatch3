//
//  YourOrdersTableViewCell.swift
//  Shoee
//
//  Created by Phincon on 29/11/23.
//

import UIKit

class YourOrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var imagePayment: UIImageView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(total: String, status: String, image: String) {
        if status.lowercased() == "settlement" {
            statusLabel.text = "Success"
        } else {
            statusLabel.text = status
        }

        totalPrice.text = total
        imagePayment.image = UIImage(named: image)
    }

    
}
