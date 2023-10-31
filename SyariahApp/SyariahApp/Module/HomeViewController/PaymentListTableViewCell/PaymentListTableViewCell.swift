//
//  PaymentListTableViewCell.swift
//  SyariahApp
//
//  Created by Phincon on 30/10/23.
//

import UIKit

class PaymentListTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
