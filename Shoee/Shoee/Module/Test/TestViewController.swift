import UIKit

class TestViewController: UIViewController {
    
    
    @IBAction func test(_ sender: Any) {
        
        showCustomSlideMess(message: "Has been removed from the Whitelist", color: UIColor(named: "Alert")!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
