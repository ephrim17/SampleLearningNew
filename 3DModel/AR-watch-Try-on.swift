import UIKit
import ARKit
import SceneKit
import SwiftUI
import simd

class ARWatchTryOnViewController: UIViewController, ARSCNViewDelegate {
    
    var sceneView: ARSCNView!
    var resetButton: UIButton!
    var overlayLabel: UILabel!
    var watchNode: SCNNode?
    var isWristDetected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up ARSCNView
        sceneView = ARSCNView(frame: view.bounds)
        sceneView.delegate = self
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(sceneView)
        
        // Configure AR session
        let configuration = ARBodyTrackingConfiguration()
        sceneView.session.run(configuration)
        
        // Load watch model
        loadWatchModel()
        
        // Set up reset button
        resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.backgroundColor = .white
        resetButton.layer.cornerRadius = 8
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetButton)
        
        NSLayoutConstraint.activate([
            resetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: 100),
            resetButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Set up overlay label
        overlayLabel = UILabel()
        overlayLabel.text = "Looking for wrists"
        overlayLabel.textColor = .white
        overlayLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        overlayLabel.textAlignment = .center
        overlayLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayLabel.layer.cornerRadius = 10
        overlayLabel.clipsToBounds = true
        overlayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayLabel)
        
        NSLayoutConstraint.activate([
            overlayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overlayLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            overlayLabel.widthAnchor.constraint(equalToConstant: 200),
            overlayLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        overlayLabel.isHidden = false
    }
    
    func loadWatchModel() {
        guard let watchURL = Bundle.main.url(forResource: "watch_ar", withExtension: "usdz") else {
            print("Watch model not found")
            return
        }
        
        do {
            let watchScene = try SCNScene(url: watchURL, options: nil)
            watchNode = watchScene.rootNode.childNodes.first
            watchNode?.isHidden = true // Hide initially
        } catch {
            print("Failed to load watch model: \(error)")
        }
    }
    
    @objc func resetTapped() {
        // Reset session and hide watch
        watchNode?.isHidden = true
        isWristDetected = false
        overlayLabel.isHidden = false
        sceneView.session.run(ARBodyTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let bodyAnchor = anchor as? ARBodyAnchor else { return }

        let leftWristTransform = bodyAnchor.skeleton.modelTransform(for: .leftHand)
        let rightWristTransform = bodyAnchor.skeleton.modelTransform(for: .rightHand)

        // Choose which wrist to use - prefer left, fallback to right
        guard let wristTransform = leftWristTransform ?? rightWristTransform else { return }

        // Wrist size detection: simple scaling based on arbitrary value or skip
        // For now, set a fixed scale
        watchNode?.scale = SCNVector3(0.1, 0.1, 0.1)

        if !isWristDetected {
            isWristDetected = true
            overlayLabel.isHidden = true
            if let watchNode = watchNode {
                watchNode.isHidden = false
                node.addChildNode(watchNode) // Attach to body node
            }
        }

        // Update watch position
        if let watchNode = watchNode {
            // Convert simd_float4x4 to SCNMatrix4 using SceneKit initializer
            let combined = simd_mul(bodyAnchor.transform, wristTransform)
            watchNode.transform = SCNMatrix4(combined)
            // Adjust orientation if needed
            watchNode.eulerAngles = SCNVector3(0, 0, Float.pi / 2)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // Body lost
        if isWristDetected {
            isWristDetected = false
            overlayLabel.isHidden = false
            watchNode?.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

// SwiftUI Wrapper
struct ARWatchTryOnView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ARWatchTryOnViewController {
        return ARWatchTryOnViewController()
    }
    
    func updateUIViewController(_ uiViewController: ARWatchTryOnViewController, context: Context) {
        // Update if needed
    }
}

