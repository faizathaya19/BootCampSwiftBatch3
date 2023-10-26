//
//  ViewController.swift
//  ProdukAwal
//
//  Created by Phincon on 25/10/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cv_data: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profilecon: UIView!
    
    @IBAction func homebutXIB(_ sender: Any) {
        
        let vc = homeXIB()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func xibbut(_ sender: Any) {
        let vc = ThViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func segueButtnact(_ sender: Any) {
        
        performSegue(withIdentifier: "secondView", sender: nil)
        
    }
    @IBOutlet weak var buttonsegue: UIButton!
    @IBOutlet weak var post: UIView!
    @IBOutlet weak var following: UIView!
    @IBOutlet weak var followers: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cv_data.layer.cornerRadius = cv_data.frame.size.width / 35
        post.layer.cornerRadius = post.frame.size.width / 25
        followers.layer.cornerRadius = followers.frame.size.width / 25
        following.layer.cornerRadius = following.frame.size.width / 25
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.contentMode = .scaleAspectFill
        profilecon.layer.cornerRadius = profilecon.frame.size.width / 20
        
        profileImageView.image( "https://cdn.idntimes.com/content-images/community/2019/01/pexels-photo-1824559-54423589976b8233c5f0701beb6374fb.jpeg")

    }
}



extension UIImageView{
    func image(_ imageURLString: String){
        if let imageURL = URL(string: imageURLString) {
            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }
            }.resume()
        }
    }
}
