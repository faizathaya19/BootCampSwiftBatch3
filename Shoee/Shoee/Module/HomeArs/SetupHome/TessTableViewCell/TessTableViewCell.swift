//
//  TessTableViewCell.swift
//  Shoee
//
//  Created by Phincon on 14/11/23.
//

import UIKit

class TessTableViewCell: UITableViewCell {
    weak var delegate: SetupHomeCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
