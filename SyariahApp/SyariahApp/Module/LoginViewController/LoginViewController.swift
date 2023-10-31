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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.setup(title: "email")
        passwordField.setup(title: "Password")
        

        // Do any additional setup after loading the view.
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
