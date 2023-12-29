import UIKit

class HeaderForTableViewCell: BaseTableCell {

    @IBOutlet weak var labelHeaderTable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func configure(title: String?) {
        labelHeaderTable.text = title
        }
    
}
