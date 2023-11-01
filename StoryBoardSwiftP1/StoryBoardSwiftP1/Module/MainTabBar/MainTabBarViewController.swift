//
//  MainTabBarController.swift
//  StoryBoardSwiftP1
//
//  Created by Phincon on 30/10/23.
//

import Foundation
import UIKit

class MainTabBarViewController: UITabBarController {
    
    let homeVC = UINavigationController(rootViewController: HomeViewController())
    let transactionVC = UINavigationController(rootViewController: ListWithStructModelViewController())
    let notificationVC = UINavigationController(rootViewController: CollectionViewController())
    let profileVC = UINavigationController(rootViewController: CollectionViewInTableViewViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUITabBarItems()
        setViewControllers()
        
    }
    
    func configureUITabBarItems(){
        homeVC.tabBarItem = UITabBarItem(title: "home", image: MainSymbols.homeSymbol, tag: 0)
        transactionVC.tabBarItem = UITabBarItem(title: "notification", image: MainSymbols.transactionSymbol, tag: 1)
        notificationVC.tabBarItem = UITabBarItem(title: "transaction", image: MainSymbols.notificationSymbol2, tag: 2)
        profileVC.tabBarItem = UITabBarItem(title: "profile", image: MainSymbols.profileSymbol3, tag: 3)
    }
    
     func setViewControllers() {
        setViewControllers([homeVC,transactionVC,notificationVC,profileVC], animated: true)
    }
    
}
