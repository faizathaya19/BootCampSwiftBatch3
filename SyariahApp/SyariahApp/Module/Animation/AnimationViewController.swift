import UIKit

class AnimationViewController: UIViewController {
    
    @IBOutlet weak var animationView: UIView!
    
    // Create a CAShapeLayer for custom shape
    private let shapeLayer = CAShapeLayer()
    
    // Flag to track the current shape state
    private var isSquare = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialShape()
    }

    @IBAction func animateButtonTapped(_ sender: UIButton) {
        toggleShape()
        animateShapeTransformation()
    }

    private func setupInitialShape() {
        // Set initial square shape
        let initialSquarePath = UIBezierPath(rect: animationView.bounds)
        shapeLayer.path = initialSquarePath.cgPath
        animationView.layer.addSublayer(shapeLayer)
    }

    private func toggleShape() {
        isSquare = !isSquare
    }

    private func animateShapeTransformation() {
        let targetPath: UIBezierPath

        if isSquare {
            // Define the square shape using a bezier path
            targetPath = UIBezierPath(rect: animationView.bounds)
        } else {
            // Define the circle shape using a bezier path
            targetPath = UIBezierPath(ovalIn: animationView.bounds)
        }

        // Create the keyframe animation for shape change
        let morphAnimation = CAKeyframeAnimation(keyPath: "path")
        morphAnimation.values = [
            shapeLayer.path!,
            targetPath.cgPath
        ]
        morphAnimation.keyTimes = [0.0, 1.0]
        morphAnimation.timingFunctions = [
            CAMediaTimingFunction(name: .easeInEaseOut),
            CAMediaTimingFunction(name: .easeInEaseOut)
        ]
        morphAnimation.duration = 1.0

        // Update the layer with the new path
        shapeLayer.add(morphAnimation, forKey: "morphAnimation")
        shapeLayer.path = targetPath.cgPath
    }
}
