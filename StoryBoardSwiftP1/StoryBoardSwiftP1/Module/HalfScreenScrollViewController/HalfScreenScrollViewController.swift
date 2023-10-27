// HalfScreenScrollViewController.swift
import UIKit

class HalfScreenScrollViewController: UIViewController {
    
    @IBOutlet weak var ImageViewTop: UIImageView!
    
    @IBOutlet weak var ImageViewData: UIImageView!
    
    // URL of the image you want to display
    let imageURLString = "https://i.pinimg.com/originals/42/3c/25/423c25cab1926d77e33c77cb7af351f1.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load image from URL
        if let imageURL = URL(string: imageURLString) {
            downloadImage(from: imageURL)
            downloadImageData(from: imageURL)
        }
    }
    
    // Function to download image from URL
    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                // Set the downloaded image to your ImageViewTop
                self.ImageViewTop.image = UIImage(data: data)
            }
        }.resume()
    }
    
    // Function to download image from URL
    func downloadImageData(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                // Set the downloaded image to your ImageViewTop
                self.ImageViewData.image = UIImage(data: data)
            }
        }.resume()
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
