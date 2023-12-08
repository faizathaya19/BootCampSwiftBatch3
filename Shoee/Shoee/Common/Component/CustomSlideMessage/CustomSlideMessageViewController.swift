import UIKit

class CustomSlideMessageViewController: UIViewController {

    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var viewContainer: UIView!

    var message: String = ""
    var color: UIColor = UIColor()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        viewContainer.layer.cornerRadius = 20.0
        viewContainer.layer.masksToBounds = true
        
        self.viewContainer.layer.backgroundColor = color.cgColor
        self.messageText.text = message

        // Add animation to show the view from the top
        let originalFrame = viewContainer.frame
        viewContainer.frame = CGRect(x: originalFrame.origin.x, y: -viewContainer.frame.height, width: originalFrame.width, height: originalFrame.height)

        // Set background color to clear and enable user interaction on the background view
        self.view.backgroundColor = UIColor.clear
        self.view.isUserInteractionEnabled = true

        UIView.animate(withDuration: 0.5, animations: {
            self.viewContainer.frame = originalFrame
        }) { (completed) in
            // Animation completed
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Add animation to hide the view after 1 second
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewContainer.frame = CGRect(x: originalFrame.origin.x, y: -self.viewContainer.frame.height, width: originalFrame.width, height: originalFrame.height)
                }) { (completed) in
                    // Animation completed
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
