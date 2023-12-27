import UIKit

class YourOrdersTableViewCell: BaseTableCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var paymentName: UILabel!
    @IBOutlet weak var imagePayment: UIImageView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var containerStatus: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.makeCornerRadius(15)
        containerStatus.makeCornerRadius(6)        
    }
    
    func configure(total: String, status: String, name: String, image: String, date: String) {
        if status.lowercased() == "settlement" {
            statusLabel.text = "Success"
            containerStatus.backgroundColor = .green
        } else if status.lowercased() == "pending" {
            statusLabel.text = "Pending"
            containerStatus.backgroundColor = .yellow
        }  else if status.lowercased() == "expire" {
            statusLabel.text = "Expired"
            containerStatus.backgroundColor = .red
        } else {
            containerStatus.backgroundColor = .clear
            statusLabel.text = status
        }

        dateLabel.text = date
        totalPrice.text = total
        paymentName.text = name
        imagePayment.image = UIImage(named: image)
    }

    
}
