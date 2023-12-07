import UIKit

class CustomSlideMessageViewController: UIViewController {

    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet var parentView: UIView!
    
    var message: String = ""
    var color: UIColor = UIColor()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let transitionView = UIApplication.shared.windows.first?.subviews.first(where: { NSStringFromClass($0.classForCoder) == "_UITransitionView" }) {
            transitionView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }


        viewContainer.layer.cornerRadius = 20.0
        viewContainer.layer.masksToBounds = true

        self.viewContainer.layer.backgroundColor = color.cgColor
        self.messageText.text = message

        let originalFrame = viewContainer.frame
        viewContainer.frame = CGRect(x: originalFrame.origin.x, y: -viewContainer.frame.height, width: originalFrame.width, height: originalFrame.height)

        self.view.backgroundColor = UIColor.green
        self.view.isUserInteractionEnabled = true

        UIView.animate(withDuration: 0.5, animations: {
            self.viewContainer.frame = originalFrame
        }) { (completed) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewContainer.frame = CGRect(x: originalFrame.origin.x, y: -self.viewContainer.frame.height, width: originalFrame.width, height: originalFrame.height)
                }) { (completed) in
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

extension CustomSlideMessageViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return CustomSlideMessagePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
