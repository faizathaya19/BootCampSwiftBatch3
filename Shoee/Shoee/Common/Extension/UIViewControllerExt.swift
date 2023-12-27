import Foundation
import UIKit
import CoreData

extension UIViewController {
    
    func showCustomAlertWith(detailResponseOkAction: (() ->())? = {}, title: String, message: String, image: UIImage?, actions: [[String: () -> Void]]?) {
        let alertVC = CustomViewPopUp.init(nibName: "CustomViewPopUp", bundle: nil)
        alertVC.titleM = title
        alertVC.message = message
        alertVC.imageItem = image
        alertVC.arrayAction = actions
        alertVC.okButtonAct = detailResponseOkAction
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showCustomPIN(completion: (() -> Void)? = nil) {
        let alertVC = CustomPINViewController.init(nibName: "CustomPINViewController", bundle: nil)
    
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .fullScreen
        alertVC.onCorrectPINEntered = {
            self.dismiss(animated: true) {
                completion?()
            }
        }
        present(alertVC, animated: true, completion: nil)
    }

}

