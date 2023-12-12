//
//  UIViewControllerExt.swift
//  Shoee
//
//  Created by Phincon on 13/11/23.
//

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
        //Present
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showCustomPIN(with itemList: [Items], dataOther: CheckOut, paymentSelectionData: PaymentSelectModel) {
        let alertVC = CustomPINViewController.init(nibName: "CustomPINViewController", bundle: nil)
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.itemList = itemList
        alertVC.dataOther = dataOther
        alertVC.paymentSelectionData = paymentSelectionData
        alertVC.onCorrectPINEntered = { [weak self] in
            let vC = PaymentProcessViewController(paymentID: alertVC.orderId!)
            vC.paymentBCA = alertVC.paymentBCA
            self?.navigationController?.pushViewController(vC, animated: true)
          }
        alertVC.generateOrderID()
        present(alertVC, animated: true, completion: nil)
    }

    
}

