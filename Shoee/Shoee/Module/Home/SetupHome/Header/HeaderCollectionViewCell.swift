import UIKit
import Kingfisher
import SkeletonView

class HeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameTopHeader: UILabel!
    @IBOutlet weak var pictureProfile: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pictureProfile.layer.cornerRadius = pictureProfile.frame.height / 2
    }

    var imageURL: URL? {
        didSet {
            loadImage()
        }
    }
    
    // MARK: - Image Loading
    
    private func loadImage() {
        guard let imageURL = imageURL else {
            pictureProfile.hideSkeleton()
            pictureProfile.image = nil
            return
        }
        
        let processor = DownsamplingImageProcessor(size: pictureProfile.bounds.size)
        pictureProfile.kf.indicatorType = .activity
        pictureProfile.kf.setImage(
            with: imageURL,
            placeholder: nil,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]) { [weak self] result in
                switch result {
                case .success(_):
                    self?.pictureProfile.hideSkeleton()
                case .failure(_):
                    self?.pictureProfile.hideSkeleton()
                }
            }
    }
    
    // MARK: - Public Methods
    
    func configure(name: String, username: String, imageURLString: String) {
        nameTopHeader.text = name
        usernameLabel.text = username
        if let imageURL = URL(string: imageURLString) {
            self.imageURL = imageURL
        }
    }
}
