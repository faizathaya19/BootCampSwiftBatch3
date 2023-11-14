import UIKit
import SwiftUI
import Foundation

class CustomMainTabBar : UITabBarController {
    
    let btnMiddle : UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        btn.setTitle("", for: .normal)
        btn.backgroundColor = UIColor(named: "Secondary")
        btn.layer.cornerRadius = 30
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.setBackgroundImage(UIImage(named: "ic_cart"), for: .normal)
        
        return btn
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        hidesBottomBarWhenPushed = false
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSomeTabItems()
        btnMiddle.frame = CGRect(x: Int(self.tabBar.bounds.width)/2 - 30, y: -20, width: 60, height: 60)
        
        btnMiddle.addTarget(self, action: #selector(btnMiddleTapped), for: .touchUpInside)
    }
    
    override func loadView() {
        super.loadView()
        self.tabBar.addSubview(btnMiddle)
        setupCustomTabBar()
      
    }
    
    @objc func btnMiddleTapped() {
        let vc = CartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addSomeTabItems() {
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: ChatViewController())
        let vc3 = UINavigationController()
        let vc4 = UINavigationController(rootViewController: FavoriteViewController())
        let vc5 = UINavigationController(rootViewController: ProfileViewController())
        vc1.title = "Home"
        vc2.title = "chat"
        vc3.title = ""
        vc4.title = "Favorite"
        vc5.title = "Profile"
        setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
        guard let items = tabBar.items else { return }
        items[0].image = UIImage(named: "ic_home")
        items[1].image = UIImage(named: "ic_chat")
        items[2].isEnabled = false
        items[3].image = UIImage(named: "ic_favorite")
        items[4].image = UIImage(named: "ic_profile")
    }
    
    func setupCustomTabBar() {
        let path: UIBezierPath = getPathForTabBar()
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 3
        shape.strokeColor = UIColor(named: "BG2")?.cgColor
        shape.fillColor = UIColor(named: "BG2")?.cgColor
        self.tabBar.layer.insertSublayer(shape, at: 0)
        self.tabBar.itemWidth = 40
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 70
        self.tabBar.tintColor = UIColor(named: "Primary")
        self.tabBar.unselectedItemTintColor = UIColor.white
    }
    
    
    
    func getPathForTabBar() -> UIBezierPath {
        let holeWidth: CGFloat = 170
        let holeHeight: CGFloat = 70
        let frameWidth = self.tabBar.bounds.width
        let frameHeight = self.tabBar.bounds.height + 40
        let leftXUntilHole = frameWidth / 2 - holeWidth / 2
        
        
        let path = UIBezierPath()
        
        // Move to the starting point
        path.move(to: CGPoint(x: 0, y: 0))
        
        // 1. Line
        path.addLine(to: CGPoint(x: leftXUntilHole, y: 0))
        
        // Part I
        path.addCurve(to: CGPoint(x: leftXUntilHole + (holeWidth / 3), y: holeHeight / 2),
                      controlPoint1: CGPoint(x: leftXUntilHole + ((holeWidth / 3) / 8) * 6, y: 0),
                      controlPoint2: CGPoint(x: leftXUntilHole + ((holeWidth / 3) / 8) * 8, y: holeHeight / 2))
        
        // Part II
        path.addCurve(to: CGPoint(x: leftXUntilHole + (2 * holeWidth) / 3, y: holeHeight / 2),
                      controlPoint1: CGPoint(x: leftXUntilHole + (holeWidth / 3) + (holeWidth / 3) / 3 * 2 / 5, y: (holeHeight / 2) * 6 / 4),
                      controlPoint2: CGPoint(x: leftXUntilHole + (holeWidth / 3) + (holeWidth / 3) / 3 * 2 + (holeWidth / 3) / 3 * 3 / 5, y: (holeHeight / 2) * 6 / 4))
        
        // Part III
        path.addCurve(to: CGPoint(x: leftXUntilHole + holeWidth, y: 0),
                      controlPoint1: CGPoint(x: leftXUntilHole + (2 * holeWidth) / 3, y: holeHeight / 2),
                      controlPoint2: CGPoint(x: leftXUntilHole + (2 * holeWidth) / 3 + (holeWidth / 3) * 2 / 8, y: 0))
        
        // 2. Line
        path.addLine(to: CGPoint(x: frameWidth, y: 0))
        
        // 3. Line
        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight))
        
        // 4. Line
        path.addLine(to: CGPoint(x: 0, y: frameHeight))
        
        // 5. Line
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        // Close the path
        path.close()
        
        return path
    }
}

extension CustomMainTabBar{
    static func shareInstance() -> CustomMainTabBar{
        return CustomMainTabBar.shareInstance()
    }
}




