import UIKit
import SkeletonView
import Kingfisher

class DetailProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.makeCornerRadius(15)
        imageView.showAnimatedGradientSkeleton(usingGradient: Constants.skeletonColor)
    }
    
    var imageURL: URL? {
        didSet {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let imageURL = imageURL else {
            imageView.hideSkeleton()
            imageView.image = nil
            return
        }
        
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: imageURL,
            placeholder: nil,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]) { result in
                switch result {
                case .success(_):
                    self.imageView.hideSkeleton()
                case .failure(_):
                    self.imageView.hideSkeleton()
                }
        }
    }
}



