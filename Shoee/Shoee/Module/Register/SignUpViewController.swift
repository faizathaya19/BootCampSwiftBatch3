//
//  RegisterViewController.swift
//  Shoee
//
//  Created by Phincon on 08/11/23.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullnameTextFieldCustom: CustomTextField!
    @IBOutlet weak var usernameTextFieldCustom: CustomTextField!
    @IBOutlet weak var emailTextFieldCustom: CustomTextField!
    @IBOutlet weak var passwordTextFieldCustom: CustomTextField!
    
    @IBAction func btnSignUp(_ sender: Any) {
        let vc = CustomMainTabBar()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        navigationController?.isNavigationBarHidden = true
    }

    func setupTextFields() {
        fullnameTextFieldCustom.setup(title: "Email", image: UIImage(named: "ic_fullname"), placeHolder: "Your Email Address")
        usernameTextFieldCustom.setup(title: "Password", image: UIImage(named: "ic_username"), placeHolder: "Your Password")
        emailTextFieldCustom.setup(title: "Password", image: UIImage(named: "ic_email"), placeHolder: "Your Password")
        passwordTextFieldCustom.setup(title: "Password", image: UIImage(named: "ic_password"), placeHolder: "Your Password")
    }
}
