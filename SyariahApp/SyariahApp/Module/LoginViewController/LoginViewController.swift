//
//  LoginViewController.swift
//  SyariahApp
//
//  Created by Phincon on 31/10/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: ReusableTextField!
    @IBOutlet weak var passwordField: ReusableTextField!
    
    @IBAction func logInButton(_ sender: Any) {
        
        let vc = MainTabBarViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.setup(title: "Email")
        passwordField.setup(title: "Password")
        
        hidesBottomBarWhenPushed = false
        navigationController?.isNavigationBarHidden = true
    }

}
