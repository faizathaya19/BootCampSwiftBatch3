import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        if (TokenService.shared.getTokenFromKeychain() != nil){
            window.rootViewController = UINavigationController(rootViewController: CustomMainTabBar())
        }else{
            window.rootViewController = UINavigationController(rootViewController: LoginViewController())
        }
        
        self.window = window
        window.backgroundColor = UIColor(named: "BG1")
        window.makeKeyAndVisible()
        UINavigationBar.appearance().isHidden = true
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
}
