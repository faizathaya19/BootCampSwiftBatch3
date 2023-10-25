//
//  ViewController.swift
//  ProdukAwal
//
//  Created by Phincon on 25/10/23.
//
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var profile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // URL Gambar Profil
        let imageURLString = "https://cdn.idntimes.com/content-images/community/2019/01/pexels-photo-1824559-54423589976b8233c5f0701beb6374fb.jpeg"

        // Memuat gambar dari URL secara asinkron
        if let imageURL = URL(string: imageURLString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    // Mendapatkan gambar di thread latar belakang
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            // Menyetel gambar ke UIImageView
                            self.profile.image = self.makeRoundedImage(image: image)
                        }
                    }
                }
            }
        }
    }

    // Fungsi untuk membuat gambar dengan sudut bulat
    func makeRoundedImage(image: UIImage) -> UIImage {
        let imageView = UIImageView(image: image)
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
}
