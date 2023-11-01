//
//  PrivacyPolicyViewController.swift
//  SyariahApp
//
//  Created by Phincon on 01/11/23.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBAction func backButton(_ sender: Any) {
        _ = RegisterViewController()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hidesBottomBarWhenPushed = true
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
