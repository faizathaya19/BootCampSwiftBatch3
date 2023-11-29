//
//  AccoountVATableViewCell.swift
//  Shoee
//
//  Created by Phincon on 29/11/23.
//

import UIKit

class AccoountVATableViewCell: BaseTableCell {

    @IBOutlet weak var containerVABottom: UIView!
    @IBOutlet weak var containerVATop: UIView!
    @IBOutlet weak var containerButton: UIView!
    
    @IBOutlet weak var containerImage: UIView!
    let cornerRadius: CGFloat = 15.0
    
  
    @IBAction func goToOrderDetails(_ sender: Any) {
        let CustomMainTabBar = CustomMainTabBar()
        let navigationController = UINavigationController(rootViewController: CustomMainTabBar)

        // Access the windowScene from the current scene delegate
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            // Set the root view controller to the navigation controller
            sceneDelegate.window?.rootViewController = navigationController
        }
    }
    @IBAction func goToHome(_ sender: Any) {
        let customMainTabBar = CustomMainTabBar()
        let navigationController = UINavigationController(rootViewController: customMainTabBar)

        // Access the windowScene from the current scene delegate
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            // Set the root view controller to the navigation controller
            sceneDelegate.window?.rootViewController = navigationController
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        containerVABottom.layer.cornerRadius = cornerRadius
        containerImage.layer.cornerRadius = 5
        // Apply corner radius to bottom right and bottom left corners
        containerButton.layer.cornerRadius = cornerRadius
        containerButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        // Apply corner radius to top right and top left corners
        containerVATop.layer.cornerRadius = cornerRadius
        containerVATop.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
