import UIKit

class ChatViewController: UIViewController, UIScrollViewDelegate {

    let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up your scroll view
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1000) // Sesuaikan dengan kebutuhan Anda
        scrollView.delegate = self
        view.addSubview(scrollView)

        // Ignore safe area adjustments for the scrollView
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }

        // Set contentInset to push content above the safe area
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        // Add your other UI elements to the scrollView
        let contentLabel = UILabel()
        contentLabel.text = "Your content here"
        scrollView.addSubview(contentLabel)
        // Add constraints for contentLabel or set its frame as needed
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Make the top and bottom safe areas transparent when scrolling
        let transparentColor = UIColor.clear.cgColor
        let scrollOffset = scrollView.contentOffset.y

        if #available(iOS 11.0, *) {
            scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            scrollView.layer.cornerRadius = 10 // Adjust the corner radius as needed

            // Top safe area
            let topSafeAreaHeight = scrollView.adjustedContentInset.top
            let topMaskHeight = min(scrollOffset, topSafeAreaHeight)
            scrollView.layer.mask = createMask(height: topMaskHeight, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])

            // Bottom safe area
            let bottomSafeAreaHeight = scrollView.adjustedContentInset.bottom
            let bottomMaskHeight = max(0, bottomSafeAreaHeight + scrollOffset - scrollView.contentSize.height)
            scrollView.layer.mask = createMask(height: bottomMaskHeight, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        }
    }

    func createMask(height: CGFloat, corners: CACornerMask) -> CALayer {
        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: height)
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.cornerRadius = scrollView.layer.cornerRadius
        maskLayer.maskedCorners = corners
        return maskLayer
    }
}
