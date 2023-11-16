import UIKit

class PopularProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var popularImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set corner radius
        self.containerView.layer.cornerRadius = 15
    }

    func configure(withImageName imageName: String) {
        popularImage.image = UIImage(named: imageName)
    }
    
    
}
