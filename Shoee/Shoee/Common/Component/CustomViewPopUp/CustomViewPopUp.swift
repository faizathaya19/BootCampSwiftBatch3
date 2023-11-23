import UIKit


class CustomViewPopUp: UIViewController{
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var detailResponseOk: UIButton!
    @IBOutlet weak var detailResponse: UILabel!
    @IBOutlet weak var titleResponse: UILabel!
    @IBOutlet weak var imageResponse: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var titleM: String = ""
    var message: String = ""
    var imageItem: UIImage?
    
    var okButtonAct: (() ->())?
    var arrayAction: [[String: () -> Void]]?
    
    @IBAction func detailResponseOkAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if arrayAction != nil {
            let dic = arrayAction![0]
            for (_, value) in dic {
                let action: () -> Void = value
                action()
            }
        } else {
            okButtonAct?()
        }
    }
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if arrayAction != nil {
            let dic = arrayAction![1]
            for (_, value) in dic {
                let action: () -> Void = value
                action()
            }
        } else {
            okButtonAct?()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewContainer.layer.cornerRadius = 20.0
        viewContainer.layer.masksToBounds = true
    
        
        self.titleResponse.text = titleM
        self.detailResponse.text = message
        
        if imageItem == nil {
            imageResponse.isHidden = true
        } else {
            imageResponse.isHidden = false
            imageResponse.image = imageItem!
        }
        
 

        if arrayAction == nil {
            cancelButton.isHidden = true
        } else {
            var count = 0
            for dic in arrayAction! {
                if count > 1 {
                    return
                }
                let allKeys = Array(dic.keys)
                let buttonTitle: String = allKeys[0]
                if count == 0 {
                    detailResponseOk.setTitle(buttonTitle, for: .normal)
                } else {
                    cancelButton.setTitle(buttonTitle, for: .normal)
                }
                count += 1
            }
        }
    }
    
    
}
