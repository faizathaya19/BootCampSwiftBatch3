//
//  ProfileViewController.swift
//  SyariahApp
//
//  Created by Phincon on 01/11/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageProfile.layer.cornerRadius = imageProfile.frame.size.width / 8
        imageProfile.layer.masksToBounds = true
        
        // Set corner radius for cameraView
        cameraView.layer.cornerRadius = 8
        cameraView.layer.masksToBounds = true
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBAction func btnImagePicker(_ sender: Any) {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        
        imageProfile.image = image
        
        dismiss(animated: true)
    }
}
