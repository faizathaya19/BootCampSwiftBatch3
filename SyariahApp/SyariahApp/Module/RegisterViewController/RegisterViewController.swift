//
//  RegisterViewController.swift
//  SyariahApp
//
//  Created by Phincon on 01/11/23.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var fullNameField: ReusableTextField!
    
    @IBAction func privacyPolicyButton(_ sender: Any) {
        
        let vc = PrivacyPolicyViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        _ = LoginViewController()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBOutlet weak var cityField: ReusableTextField!
    
    @IBOutlet weak var emailField: ReusableTextField!
    
    @IBOutlet weak var passwordField: ReusableTextField!
    
//    @IBAction func sss(_ sender: UIImage){
//        if sender.isSelected {
//            sender.isSelected = false
//        } else {
//            sender.isSelected = true
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fullNameField.setup(title: "Full Name")
        cityField.setup(title: "City")
        emailField.setup(title: "Email")
        passwordField.setup(title: "Password")
        
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
