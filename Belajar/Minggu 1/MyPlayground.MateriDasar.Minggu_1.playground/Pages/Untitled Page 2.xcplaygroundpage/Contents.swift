import UIKit
import PlaygroundSupport

class ViewCon : UIViewController {
    let myView : UIView = {
        let view = UIView(frame: CGRect(x: 10, y:100, width: 400, height: 500))
        view.backgroundColor = .blue
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
    
    override func loadView() {
        
    }
}

PlaygroundPage.current.liveView = ViewCon()
