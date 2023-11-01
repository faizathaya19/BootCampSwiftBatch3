//
//  HomeViewController.swift
//  StoryBoardSwiftP1
//
//  Created by Phincon on 01/11/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var walleticon: UIImageView!
    @IBOutlet weak var paymenticon: UIImageView!
    @IBOutlet weak var archiveicon: UIImageView!
    @IBOutlet weak var othericon: UIImageView!
    
    @IBOutlet weak var Username: UILabel!
    var username = String()
    
    
    @IBAction func imagePicker(_ sender: Any) {
        let vc = ImagePickerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func TableInCollectionButton(_ sender: Any) {
        let vc = CollectionViewInTableViewViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func CollectionButton(_ sender: Any) {
        
        let vc = CollectionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func FullScreenScrollButoon(_ sender: Any) {
        let vc = ScrollFullScreenViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func XIBButton(_ sender: Any) {
        let vc = ScreenXIBViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func StoryboardButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "StoryboardScreen")
                self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        topView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)

        let walletImage = UIImage(named: "waleth")
        walleticon.image = walletImage

        let archiveImage = UIImage(named: "waleth")
        archiveicon.image = archiveImage

        let paymentImage = UIImage(named: "waleth")
        paymenticon.image = paymentImage

        let otherImage = UIImage(named: "waleth")
        othericon.image = otherImage

        // URL Gambar Profil
        let imageURLString = "https://cdn.idntimes.com/content-images/community/2019/01/pexels-photo-1824559-54423589976b8233c5f0701beb6374fb.jpeg"
        profileimage.layer.cornerRadius = profileimage.frame.size.width / 2
        profileimage.contentMode = .scaleAspectFill

        // Memuat gambar dari URL secara asinkron
        if let imageURL = URL(string: imageURLString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    // Mendapatkan gambar di thread latar belakang
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            // Menyetel gambar ke UIImageView dan membuatnya berbentuk lingkaran
                            self.profileimage.image = self.makeCircularImage(image: image)
                        }
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    
    
    func makeCircularImage(image: UIImage) -> UIImage {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true

        UIGraphicsBeginImageContext(imageView.bounds.size)
        defer { UIGraphicsEndImageContext() }

        if let context = UIGraphicsGetCurrentContext() {
            imageView.layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext() ?? image
        }

        return image
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
