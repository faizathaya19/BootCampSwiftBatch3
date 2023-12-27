import UIKit

class StatusOrderTableViewCell: BaseTableCell {

    @IBOutlet weak var transactionDate: UILabel!
    @IBOutlet weak var statusOrder: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(status: String, date: String){
        
        if status.lowercased() == "settlement" {
            statusOrder.text = "Success"
            
        } else if status.lowercased() == "pending" {
            statusOrder.text = "Pending"
            
        }  else if status.lowercased() == "expire" {
            statusOrder.text = "Expired"
            
        } else {
            
            statusOrder.text = status
        }
        
        transactionDate.text = date
    }
}
