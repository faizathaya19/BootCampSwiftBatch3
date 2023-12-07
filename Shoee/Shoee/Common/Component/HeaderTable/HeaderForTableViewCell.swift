//
//  HeaderForTableViewCell.swift
//  Shoee
//
//  Created by Phincon on 06/12/23.
//

import UIKit

class HeaderForTableViewCell: BaseTableCell {

    @IBOutlet weak var labelHeaderTable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(title: String?) {
        labelHeaderTable.text = title
        }
    
}
