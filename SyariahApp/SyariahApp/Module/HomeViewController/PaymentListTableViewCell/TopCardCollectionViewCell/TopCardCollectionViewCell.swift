import UIKit

class TopCardCollectionViewCell: UICollectionViewCell, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var topBarCollectionView: UIView!
    
    @IBAction func qrisButton(_ sender: Any) {
        openCamera()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func openCamera() {
        // Check if the device has a camera
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = .camera
        cameraPicker.delegate = self // Make sure your class conforms to UIImagePickerControllerDelegate
        cameraPicker.allowsEditing = false

        // Present the camera
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.present(cameraPicker, animated: true, completion: nil)
        }
    }
}
