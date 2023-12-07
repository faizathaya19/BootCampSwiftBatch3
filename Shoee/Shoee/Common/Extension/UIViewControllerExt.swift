//
//  UIViewControllerExt.swift
//  Shoee
//
//  Created by Phincon on 13/11/23.
//

import Foundation
import UIKit

extension UIViewController {
      
    func showCustomAlertWith(detailResponseOkAction: (() ->())? = {}, title: String, message: String, image: UIImage?, actions: [[String: () -> Void]]?) {
        let alertVC = CustomViewPopUp.init(nibName: "CustomViewPopUp", bundle: nil)
        alertVC.titleM = title
        alertVC.message = message
        alertVC.imageItem = image
        alertVC.arrayAction = actions
        alertVC.okButtonAct = detailResponseOkAction
        //Present
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showCustomSlideMess(message: String, color: UIColor) {
        let alertVC = CustomSlideMessageViewController.init(nibName: "CustomSlideMessageViewController", bundle: nil)
        alertVC.message = message
        alertVC.color = color

        alertVC.modalPresentationStyle = .custom
        alertVC.transitioningDelegate = alertVC

        present(alertVC, animated: true, completion: nil)
    }

    
    func showCustomPIN(with itemList: [Items], dataOther: [CheckOut]) {
        let alertVC = CustomPINViewController.init(nibName: "CustomPINViewController", bundle: nil)
        let vc = CustomPINViewController.init(nibName: "CustomPINViewController", bundle: nil)

        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.itemList = itemList
        alertVC.dataOther = dataOther
        alertVC.onCorrectPINEntered = { [weak self] in
            let vC = PaymentProcessViewController()
            self?.navigationController?.pushViewController(vC, animated: true)
        }

        present(alertVC, animated: true, completion: nil)
    }



    
}

class CustomSlideMessagePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: containerView!.bounds.height - 200, width: containerView!.bounds.width, height: 200)
    }
}
