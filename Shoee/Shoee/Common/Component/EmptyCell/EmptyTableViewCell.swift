import UIKit

protocol EmptyCellDelegate: AnyObject {
    func btnAction(inCell cell: EmptyTableViewCell)
}

class EmptyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnText: UIButton!
    @IBOutlet weak var imageEmpty: UIImageView!
    @IBOutlet weak var messageEmpty: UILabel!
    @IBOutlet weak var titleEmpty: UILabel!
    
    var btnTextValue: String? {
            didSet {
                btnText.setTitle(btnTextValue, for: .normal)
            }
        }
    
    weak var delegate: EmptyCellDelegate?
    
    @IBAction func btnAction(_ sender: Any) {
        delegate?.btnAction(inCell: self)
    }
    
    func configure(withImageNamed imageName: String, message: String, title: String) {
        imageEmpty.image = UIImage(named: imageName)
        messageEmpty.text = message
        titleEmpty.text = title
    }

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

}
