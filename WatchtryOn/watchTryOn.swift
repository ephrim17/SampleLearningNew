//
//  watchTryOn.swift
//  sample
//
//  Created by ephrim.daniel on 11/12/25.
//

import UIKit
import ARKit
import Vision
import RealityKit // or SceneKit if preferred

class ViewController: UIViewController, ARSessionDelegate {

    // MARK: - Properties
    private var arView: ARView!
    private let visionQueue = DispatchQueue(label: "vision.handpose.queue")
    private var handPoseRequest = VNDetectHumanHandPoseRequest()
    private var watchAnchor: AnchorEntity?
    private var watchModelEntity: ModelEntity?
    
    // Recursively print all entity names for debugging
    private func listAllEntityNames(for entity: Entity, indent: String = "") {
        let name = entity.name.isEmpty ? "<unnamed>" : entity.name
        print("\(indent)\(name) : \(type(of: entity))")
        for child in entity.children {
            listAllEntityNames(for: child, indent: indent + "  ")
        }
    }
    
    private let watchColors: [(name: String, color: UIColor)] = [
        ("Black", .black), ("Silver", UIColor(white: 0.85, alpha: 1)), ("Gold", UIColor(red: 0.85, green: 0.71, blue: 0.39, alpha: 1)), ("Blue", .systemBlue), ("Red", .systemRed)
    ]
    private var lastWristTransform: simd_float4x4?
    // If the watch face is rotated, adjust `correctiveDegreesXYZ` inside `orientationForWrist` (try Y: 0, 90, 180, 270)
    
    // Debug tuning for orientation
    private var debugFlipForward: Bool = true
    private var debugFlipUp: Bool = false
    private var debugCorrectiveY: Float = 180 // allowed: 0, 90, 180, 270
    private var debugPanel: UIView? = nil
    
    private var lastDetectionTime: TimeInterval = 0
    private let detectionGraceInterval: TimeInterval = 0.5
    private var isWristDetected: Bool = false
    private var consecutiveMisses: Int = 0
    private let maxMissesBeforeHide: Int = 8
    private var lastDetectionTimestamp: TimeInterval = 0
    private let hideTimeout: TimeInterval = 0.3
    private var loadingOverlay: UIView = UIView()
    private var loadingLabel: UILabel = UILabel()
    private var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    private var colorBarContainer: UIVisualEffectView?
    private var swatchButtons: [UIButton] = []

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupARView()
        setupVision()
        setupLoadingOverlay()
        setupDebugPanel()
        setupColorBar()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(toggleDebugPanel(_:)))
        longPress.minimumPressDuration = 0.8
        view.addGestureRecognizer(longPress)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
        lastWristTransform = nil
    }

    // MARK: - Setup
    private func setupARView() {
        arView = ARView(frame: self.view.bounds)
        self.view.addSubview(arView)
        arView.session.delegate = self
        setupResetButton()
        // Load your watch 3D model (ensure you have a 'WatchModel.usdz' in your assets)
        if let watchModel = try? ModelEntity.loadModel(named: "watch_ar") {
            watchAnchor = AnchorEntity()
            watchAnchor?.addChild(watchModel)
            watchModel.scale = SIMD3<Float>(0.4, 0.4, 0.4)
            self.watchModelEntity = watchModel
            // Apply a default color
            self.applyWatchColor(UIColor.black)
            
            print("--- Starting Entity List ---")
            listAllEntityNames(for: watchModel)
            print("--- End of Entity List ---")
        }
    }
    
    private func setupVision() {
        handPoseRequest.maximumHandCount = 1
    }

    private func setupResetButton() {
//        let button = UIButton(type: .system)
//        button.setTitle("Reset AR", for: .normal)
//        button.backgroundColor = UIColor.systemGray.withAlphaComponent(0.7)
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 10
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(resetARSession), for: .touchUpInside)
//        self.view.addSubview(button)
//        NSLayoutConstraint.activate([
//            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
//            button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            button.widthAnchor.constraint(equalToConstant: 100),
//            button.heightAnchor.constraint(equalToConstant: 40)
//        ])
    }
    
    @objc private func resetARSession() {
        let configuration = ARWorldTrackingConfiguration()
        // Pause session and clear scene anchors
        arView.session.pause()
        arView.scene.anchors.removeAll()
        // Reset internal state
        lastWristTransform = nil
        isWristDetected = false
        consecutiveMisses = 0
        lastDetectionTimestamp = 0
        // Ensure the loading overlay is visible so we "start looking for wrist again"
        loadingOverlay.isHidden = false
        loadingOverlay.alpha = 1
        view.bringSubviewToFront(loadingOverlay)
        // Ensure watch anchor exists and is hidden until detection
        if watchAnchor == nil {
            if let watchModel = try? ModelEntity.loadModel(named: "watch_ar") {
                let anchor = AnchorEntity()
                anchor.addChild(watchModel)
                watchModel.scale = SIMD3<Float>(0.4, 0.4, 0.4)
                watchAnchor = anchor
                self.watchModelEntity = watchModel
                self.applyWatchColor(UIColor.black)
            }
        }
        if let anchor = watchAnchor {
            // Ensure not visible until detection resumes
            setWatchVisible(false, animated: false)
            if anchor.parent == nil { arView.scene.addAnchor(anchor) }
        }
        // Restart session with reset options so tracking and anchors are fresh
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func setupLoadingOverlay() {
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.isUserInteractionEnabled = false

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        loadingIndicator.color = .white
        loadingIndicator.startAnimating()

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        // Placeholder simple shape if no asset: use system symbol
        imageView.image = UIImage(systemName: "applewatch")
        imageView.tintColor = .white

        loadingLabel.text = "detecting wrist hold on"
        loadingLabel.textColor = .white
        loadingLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)

        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(loadingIndicator)
        stack.addArrangedSubview(loadingLabel)

        overlay.addSubview(stack)
        view.addSubview(overlay)
        view.bringSubviewToFront(overlay)

        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 140),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            stack.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
        ])

        self.loadingOverlay = overlay
        self.loadingOverlay.isHidden = false
        self.loadingOverlay.alpha = 1
    }
    
    private func setupDebugPanel() {
        let panel = UIView()
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        panel.layer.cornerRadius = 10

        let yLabel = UILabel()
        yLabel.text = "Y"
        yLabel.textColor = .white

        let seg = UISegmentedControl(items: ["0","90","180","270"])
        seg.selectedSegmentIndex = 2
        seg.addTarget(self, action: #selector(onYSegmentChanged(_:)), for: .valueChanged)

        let flipForwardSwitch = UISwitch()
        flipForwardSwitch.isOn = debugFlipForward
        flipForwardSwitch.addTarget(self, action: #selector(onFlipForwardChanged(_:)), for: .valueChanged)
        let flipForwardLabel = UILabel()
        flipForwardLabel.text = "Face Out"
        flipForwardLabel.textColor = .white

        let flipUpSwitch = UISwitch()
        flipUpSwitch.isOn = debugFlipUp
        flipUpSwitch.addTarget(self, action: #selector(onFlipUpChanged(_:)), for: .valueChanged)
        let flipUpLabel = UILabel()
        flipUpLabel.text = "Band Up"
        flipUpLabel.textColor = .white

        let stack = UIStackView(arrangedSubviews: [yLabel, seg, flipForwardLabel, flipForwardSwitch, flipUpLabel, flipUpSwitch])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        panel.addSubview(stack)
        view.addSubview(panel)
        
        // Keep debug panel above the loading overlay if it exists
        if let overlay = self.loadingOverlay.superview != nil ? self.loadingOverlay : nil {
            view.bringSubviewToFront(panel)
        }

        NSLayoutConstraint.activate([
            panel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            panel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),

            stack.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: panel.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -8)
        ])
        panel.alpha = 0 
        self.debugPanel = panel
    }

    private func setupColorBar() {
        let bar = UIStackView()
        bar.axis = .horizontal
        bar.alignment = .center
        bar.distribution = .fillProportionally
        bar.spacing = 10
        bar.translatesAutoresizingMaskIntoConstraints = false

        // Clear any existing list and rebuild
        self.swatchButtons.removeAll()

        for (index, item) in watchColors.enumerated() {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 36).isActive = true
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true
            button.layer.cornerRadius = 18
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.withAlphaComponent(0.55).cgColor
            button.backgroundColor = item.color
            button.tag = index

            // Add shadow and highlight for depth
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.25
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowRadius = 3

            // Touch down/up animations for delightful feel
            button.addTarget(self, action: #selector(onSwatchTouchDown(_:)), for: [.touchDown, .touchDragEnter])
            button.addTarget(self, action: #selector(onSwatchTouchUp(_:)), for: [.touchCancel, .touchDragExit, .touchUpInside, .touchUpOutside])

            button.addTarget(self, action: #selector(onColorTapped(_:)), for: .touchUpInside)

            bar.addArrangedSubview(button)
            self.swatchButtons.append(button)
        }

        // Glass container using blur effect
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let glass = UIVisualEffectView(effect: blur)
        glass.translatesAutoresizingMaskIntoConstraints = false

        // Optional: subtle vibrancy-like overlay using an extra visual effect view
        let overlay = UIVisualEffectView(effect: nil)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.isUserInteractionEnabled = false
        overlay.backgroundColor = UIColor.white.withAlphaComponent(0.06)
        overlay.layer.cornerRadius = 16
        overlay.clipsToBounds = true

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear

        // Rounded corners and border on the glass container
        glass.layer.cornerRadius = 16
        glass.clipsToBounds = true
        glass.layer.borderColor = UIColor.white.withAlphaComponent(0.22).cgColor
        glass.layer.borderWidth = 1

        // Inner highlight (top gradient-like) using a thin view
        let highlight = UIView()
        highlight.translatesAutoresizingMaskIntoConstraints = false
        highlight.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        highlight.layer.cornerRadius = 16
        highlight.clipsToBounds = true

        glass.contentView.addSubview(container)
        glass.contentView.addSubview(overlay)
        glass.contentView.addSubview(highlight)
        container.addSubview(bar)

        view.addSubview(glass)

        NSLayoutConstraint.activate([
            // Glass placement
            glass.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            glass.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),

            // Container edges inside glass
            container.leadingAnchor.constraint(equalTo: glass.contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: glass.contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: glass.contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: glass.contentView.bottomAnchor),

            // Overlay fills glass for subtle tint
            overlay.leadingAnchor.constraint(equalTo: glass.contentView.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: glass.contentView.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: glass.contentView.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: glass.contentView.bottomAnchor),

            // Highlight at the top edge for sheen
            highlight.leadingAnchor.constraint(equalTo: glass.contentView.leadingAnchor),
            highlight.trailingAnchor.constraint(equalTo: glass.contentView.trailingAnchor),
            highlight.topAnchor.constraint(equalTo: glass.contentView.topAnchor),
            highlight.heightAnchor.constraint(equalToConstant: 2),

            // Bar insets
            bar.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            bar.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),
            bar.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            bar.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])

        // Size the glass to fit content
        let height = 56.0
        let width = CGFloat(watchColors.count) * 36.0 + CGFloat(max(0, watchColors.count - 1)) * 10.0 + 28.0
        let widthConstraint = glass.widthAnchor.constraint(equalToConstant: width)
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        let heightConstraint = glass.heightAnchor.constraint(equalToConstant: height)
        heightConstraint.priority = .required
        heightConstraint.isActive = true

        // Save reference
        self.colorBarContainer = glass

        // Appear animation
        glass.alpha = 0
        glass.transform = CGAffineTransform(translationX: 0, y: 12)
        UIView.animate(withDuration: 0.35, delay: 0.15, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.6, options: [.allowUserInteraction, .beginFromCurrentState]) {
            glass.alpha = 1
            glass.transform = .identity
        }
    }

    @objc private func onYSegmentChanged(_ sender: UISegmentedControl) {
        let values: [Float] = [0, 90, 180, 270]
        let idx = max(0, min(sender.selectedSegmentIndex, values.count-1))
        debugCorrectiveY = values[idx]
    }

    @objc private func onFlipForwardChanged(_ sender: UISwitch) {
        debugFlipForward = sender.isOn
    }

    @objc private func onFlipUpChanged(_ sender: UISwitch) {
        debugFlipUp = sender.isOn
    }

    @objc private func toggleDebugPanel(_ gesture: UILongPressGestureRecognizer) {
        guard let panel = debugPanel, gesture.state == .began else { return }
        let hidden = !panel.isHidden
        panel.isHidden = hidden
        panel.alpha = hidden ? 0 : 1
    }
    
    @objc private func onColorTapped(_ sender: UIButton) {
        let idx = sender.tag
        guard watchColors.indices.contains(idx) else { return }
        let color = watchColors[idx].color
        applyWatchColor(color)
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        // Subtle shimmer on the glass container
        if let glass = self.colorBarContainer {
            let shimmer = CAGradientLayer()
            shimmer.colors = [
                UIColor.clear.cgColor,
                UIColor.white.withAlphaComponent(0.25).cgColor,
                UIColor.clear.cgColor
            ]
            shimmer.startPoint = CGPoint(x: 0, y: 0.5)
            shimmer.endPoint = CGPoint(x: 1, y: 0.5)
            shimmer.locations = [0, 0.5, 1]
            shimmer.frame = glass.bounds.insetBy(dx: -glass.bounds.width, dy: 0)
            glass.layer.addSublayer(shimmer)

            let anim = CABasicAnimation(keyPath: "position.x")
            anim.fromValue = -glass.bounds.width
            anim.toValue = glass.bounds.width * 2
            anim.duration = 0.8
            anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            CATransaction.begin()
            CATransaction.setCompletionBlock { shimmer.removeFromSuperlayer() }
            shimmer.add(anim, forKey: "shimmer")
            CATransaction.commit()
        }
    }
    
    @objc private func onSwatchTouchDown(_ sender: UIButton) {
        let scaleDown = CGAffineTransform(scaleX: 0.9, y: 0.9)
        let lift: CGFloat = 6
        UIView.animate(withDuration: 0.12, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
            sender.transform = scaleDown.translatedBy(x: 0, y: -2)
            sender.layer.shadowOpacity = 0.35
            sender.layer.shadowRadius = 5
            sender.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }

    @objc private func onSwatchTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.28, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [.beginFromCurrentState, .allowUserInteraction]) {
            sender.transform = .identity
            sender.layer.shadowOpacity = 0.25
            sender.layer.shadowRadius = 3
            sender.layer.shadowOffset = CGSize(width: 0, height: 2)
        }

        // Subtle selection pulse when actually tapped inside
        if sender.isTouchInside {
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.fromValue = 1.0
            pulse.toValue = 1.06
            pulse.initialVelocity = 0.8
            pulse.damping = 6
            pulse.stiffness = 150
            pulse.mass = 0.6
            pulse.duration = pulse.settlingDuration
            sender.layer.add(pulse, forKey: "pulse")
        }
    }

    // MARK: - ARSessionDelegate
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Process frames for hand detection on a background queue
        visionQueue.async {
            let handler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage, orientation: .up, options: [:])
            do {
                try handler.perform([self.handPoseRequest])
                let observation = self.handPoseRequest.results?.first
                if let obs = observation {
                    // Process only when we actually have an observation this frame
                    self.processHandPoseObservation(obs, frame: frame)
                    // Reset miss counters on success (use frame timestamp to avoid wall-clock races)
                    self.lastDetectionTimestamp = frame.timestamp
                    self.consecutiveMisses = 0
                } else {
                    // No hand this frame: increment miss counters and hide when threshold exceeded
                    self.consecutiveMisses += 1
                    let elapsed = frame.timestamp - self.lastDetectionTimestamp
                    if self.consecutiveMisses >= self.maxMissesBeforeHide || elapsed > self.hideTimeout {
                        DispatchQueue.main.async {
                            self.setDetectionState(detected: false)
                            // Also ensure the watch is removed from the scene when not detected
                            self.setWatchVisible(false, animated: true)
                            self.lastWristTransform = nil
                        }
                    }
                }
            } catch {
                print("Hand pose detection failed: \(error)")
            }
        }
    }
    
    // MARK: - Hand Pose Processing
    private func processHandPoseObservation(_ observation: VNHumanHandPoseObservation, frame: ARFrame) {
        guard let wristPoint = try? observation.recognizedPoint(.wrist) else { return }
        
        if wristPoint.confidence > 0.5 {
            // Update detection time immediately on background thread to reduce race
            self.lastDetectionTime = CACurrentMediaTime()
            self.lastDetectionTimestamp = frame.timestamp
            self.consecutiveMisses = 0
            
            // Gather a second landmark to build a stable forearm axis
            let indexKnuckle = (try? observation.recognizedPoint(.indexMCP))
            let axisImage: SIMD2<Float>? = {
                if let idx = indexKnuckle, idx.confidence > 0.3 {
                    let w = SIMD2<Float>(Float(wristPoint.location.x), Float(wristPoint.location.y))
                    let i = SIMD2<Float>(Float(idx.location.x), Float(idx.location.y))
                    let axis = normalize(i - w)
                    if all(axis .== axis) { return axis }
                }
                return nil
            }()

            // Pass both landmarks forward for world-space reconstruction
            let indexPointOpt: VNRecognizedPoint? = indexKnuckle

            DispatchQueue.main.async {
                self.setDetectionState(detected: true)
                self.setWatchVisible(true, animated: true)
            }

            DispatchQueue.main.async {
                self.placeWatchAtWrist(wristPoint, indexPoint: indexPointOpt, frame: frame, wristAxisImage: axisImage)
            }
        }
    }
    
    // Computes a quaternion that aligns the watch so its face points outward and its band aligns with the wrist axis.
    private func orientationForWrist(using basisTransform: simd_float4x4, wristAxisWorld: SIMD3<Float>?) -> simd_quatf {
        // Use runtime-tunable debug parameters
        let flipForward = debugFlipForward
        let flipUp = debugFlipUp
        let correctiveDegreesXYZ: SIMD3<Float> = SIMD3<Float>(0, debugCorrectiveY, 0)

        // Build surface frame from raycast
        let surfaceForwardBase = normalize(SIMD3<Float>(-basisTransform.columns.2.x, -basisTransform.columns.2.y, -basisTransform.columns.2.z))
        let surfaceForward = flipForward ? -surfaceForwardBase : surfaceForwardBase

        var upBase = normalize(SIMD3<Float>(basisTransform.columns.1.x, basisTransform.columns.1.y, basisTransform.columns.1.z))

        // Use wrist axis when available for a more stable band alignment
        if let axis = wristAxisWorld {
            let projected = normalize(axis - dot(axis, surfaceForward) * surfaceForward)
            if all(projected .== projected) { // not NaN
                upBase = projected
            }
        }
        let up = flipUp ? -upBase : upBase

        let right = normalize(cross(up, surfaceForward))
        let correctedUp = normalize(cross(surfaceForward, right))

        let rot3x3 = float3x3(columns: (
            SIMD3<Float>(right.x, right.y, right.z),
            SIMD3<Float>(correctedUp.x, correctedUp.y, correctedUp.z),
            SIMD3<Float>(surfaceForward.x, surfaceForward.y, surfaceForward.z)
        ))
        var worldQuat = simd_quatf(rot3x3)

        // Ensure the face looks toward the camera when it's accidentally backwards
        if let currentFrame = arView?.session.currentFrame {
            // Compute camera forward in world space
            let camFwd = normalize(SIMD3<Float>(-currentFrame.camera.transform.columns.2.x, -currentFrame.camera.transform.columns.2.y, -currentFrame.camera.transform.columns.2.z))
            // Face normal as we constructed the surface frame (surfaceForward)
            let faceNormal = surfaceForward
            // If face normal points away from camera (dot < 0), rotate 180º about up
            if dot(faceNormal, camFwd) < 0 {
                let flip180 = simd_quatf(angle: .pi, axis: correctedUp)
                worldQuat = flip180 * worldQuat
            }
        }

        // Corrective rotation to align the model's local axes to the desired frame.
        // Many watch assets are authored with +Y as face normal or +X as forward; adjust here.
        let toRadians: (Float) -> Float = { $0 * .pi / 180 }
        let rx = simd_quatf(angle: toRadians(correctiveDegreesXYZ.x), axis: SIMD3<Float>(1,0,0))
        let ry = simd_quatf(angle: toRadians(correctiveDegreesXYZ.y), axis: SIMD3<Float>(0,1,0))
        let rz = simd_quatf(angle: toRadians(correctiveDegreesXYZ.z), axis: SIMD3<Float>(0,0,1))
        let corrective = rz * ry * rx

        return simd_normalize(worldQuat * corrective)
    }
    
    private func placeWatchAtWrist(_ wristPoint: VNRecognizedPoint, indexPoint: VNRecognizedPoint?, frame: ARFrame, wristAxisImage axisImage: SIMD2<Float>? = nil) {
        guard let anchor = watchAnchor else { return }
        // Convert Vision normalized points to screen coordinates (UIKit origin top-left, Vision origin bottom-left)
        let wristNorm = CGPoint(x: CGFloat(wristPoint.location.x), y: CGFloat(1 - wristPoint.location.y))
        let screenSize = arView.bounds.size
        let wristScreen = CGPoint(x: wristNorm.x * screenSize.width, y: wristNorm.y * screenSize.height)

        var indexScreen: CGPoint? = nil
        if let idx = indexPoint, idx.confidence > 0.3 {
            let idxNorm = CGPoint(x: CGFloat(idx.location.x), y: CGFloat(1 - idx.location.y))
            indexScreen = CGPoint(x: idxNorm.x * screenSize.width, y: idxNorm.y * screenSize.height)
        }

        // Raycast both points into world. Prefer estimated planes to always get an intersection on skin.
        let wristHit = arView.raycast(from: wristScreen, allowing: .estimatedPlane, alignment: .any).first
        let indexHit = indexScreen.flatMap { arView.raycast(from: $0, allowing: .estimatedPlane, alignment: .any).first }

        // Compute world-space wrist axis from two nearby hits when available
        var wristAxisWorld: SIMD3<Float>? = nil
        if let w = wristHit?.worldTransform, let i = indexHit?.worldTransform {
            let wPos = SIMD3<Float>(w.columns.3.x, w.columns.3.y, w.columns.3.z)
            let iPos = SIMD3<Float>(i.columns.3.x, i.columns.3.y, i.columns.3.z)
            let dir = iPos - wPos
            if length(dir) > 0.0001 { wristAxisWorld = normalize(dir) }
        } else if let axisImage = axisImage {
            // Fallback: approximate axis using image-space direction by sampling a second point near the wrist
            let p2 = CGPoint(x: wristScreen.x + CGFloat(axisImage.x) * 20.0, y: wristScreen.y - CGFloat(axisImage.y) * 20.0)
            let r1 = arView.raycast(from: wristScreen, allowing: .estimatedPlane, alignment: .any).first
            let r2 = arView.raycast(from: p2, allowing: .estimatedPlane, alignment: .any).first
            if let a = r1?.worldTransform, let b = r2?.worldTransform {
                let aPos = SIMD3<Float>(a.columns.3.x, a.columns.3.y, a.columns.3.z)
                let bPos = SIMD3<Float>(b.columns.3.x, b.columns.3.y, b.columns.3.z)
                let dir = bPos - aPos
                if length(dir) > 0.0001 { wristAxisWorld = normalize(dir) }
            }
        }

        // Use raycast results for placement
        if let result = wristHit {
            let newTransform = result.worldTransform
            var smoothedTransform: simd_float4x4
            if let last = lastWristTransform {
                let currentPos = last.columns.3
                let targetPos = newTransform.columns.3
                let lerpT: Float = 0.25
                let lerpedPos = simd_mix(currentPos, targetPos, simd_float4(repeating: lerpT))
                smoothedTransform = last
                smoothedTransform.columns.3 = lerpedPos
            } else {
                smoothedTransform = newTransform
            }

            // Build a robust orientation frame
            // Normal from raycast (points opposite of surface Z)
            let normal = normalize(SIMD3<Float>(-smoothedTransform.columns.2.x, -smoothedTransform.columns.2.y, -smoothedTransform.columns.2.z))
            var tangent = wristAxisWorld ?? normalize(SIMD3<Float>(smoothedTransform.columns.0.x, smoothedTransform.columns.0.y, smoothedTransform.columns.0.z))
            // Ensure tangent is orthogonal to normal
            tangent = normalize(tangent - dot(tangent, normal) * normal)
            let bitangent = normalize(cross(normal, tangent))

            // Compose rotation matrix: right=tangent, up=bitangent, forward=normal
            let rot3x3 = float3x3(columns: (
                SIMD3<Float>(tangent.x, tangent.y, tangent.z),
                SIMD3<Float>(bitangent.x, bitangent.y, bitangent.z),
                SIMD3<Float>(normal.x, normal.y, normal.z)
            ))
            var worldQuat = simd_quatf(rot3x3)

            // Apply corrective rotation around local axes (Y adjustment already tunable)
            let toRadians: (Float) -> Float = { $0 * .pi / 180 }
            let rx = simd_quatf(angle: toRadians(0), axis: SIMD3<Float>(1,0,0))
            let ry = simd_quatf(angle: toRadians(debugCorrectiveY), axis: SIMD3<Float>(0,1,0))
            let rz = simd_quatf(angle: toRadians(0), axis: SIMD3<Float>(0,0,1))
            worldQuat = simd_normalize(rz * ry * rx * worldQuat)
            anchor.orientation = worldQuat

            // Lift slightly along normal to avoid skin intersection
            let lift: Float = 0.012
            var lifted = smoothedTransform
            lifted.columns.3.x += normal.x * lift
            lifted.columns.3.y += normal.y * lift
            lifted.columns.3.z += normal.z * lift
            anchor.transform = Transform(matrix: lifted)
            lastWristTransform = lifted

            self.applyDistanceBasedScale(to: anchor, from: frame.camera)
            return
        }
        
        // 3. Fallback: Project forward from camera if raycast fails
        let camera = frame.camera
        let cameraTransform = camera.transform
        // Offset the watch 0.35 meters in front of the camera
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.35
        let fallbackTransform = simd_mul(cameraTransform, translation)
        
        // Slight lift along camera forward so it doesn't intersect
        var liftedFallback = fallbackTransform
        liftedFallback.columns.3.z += -0.01
        anchor.transform = Transform(matrix: liftedFallback)
        
        // Face the camera in fallback so the watch face is visible
        let camForward = normalize(SIMD3<Float>(-cameraTransform.columns.2.x, -cameraTransform.columns.2.y, -cameraTransform.columns.2.z))
        let worldUp = SIMD3<Float>(0,1,0)
        let right = normalize(cross(worldUp, camForward))
        let up = normalize(cross(camForward, right))
        let rot = float3x3(columns: (
            SIMD3<Float>(right.x, right.y, right.z),
            SIMD3<Float>(up.x, up.y, up.z),
            SIMD3<Float>(camForward.x, camForward.y, camForward.z)
        ))
        // Apply camera-facing correction and debug corrective Y rotation
        var fallbackQuat = simd_quatf(rot)
        // Ensure face normal points toward camera; if not, flip 180° about up
        let faceNormal = camForward
        if dot(faceNormal, camForward) < 0 {
            let flip180 = simd_quatf(angle: .pi, axis: up)
            fallbackQuat = flip180 * fallbackQuat
        }
        // Apply same corrective Y rotation used elsewhere
        let toRadians: (Float) -> Float = { $0 * .pi / 180 }
        let ry = simd_quatf(angle: toRadians(debugCorrectiveY), axis: SIMD3<Float>(0,1,0))
        anchor.orientation = simd_normalize(fallbackQuat * ry)
        
        self.applyDistanceBasedScale(to: anchor, from: frame.camera)
        lastWristTransform = liftedFallback
    }
    
    // Scales the anchor based on camera distance so the watch appears at a consistent size
    private func applyDistanceBasedScale(to anchor: AnchorEntity, from camera: ARCamera, targetVisualSizeMeters: Float = 0.045) {
        // Estimate distance from camera to anchor
        let cameraPos = camera.transform.columns.3
        let anchorPos = anchor.transform.matrix.columns.3
        let dx = anchorPos.x - cameraPos.x
        let dy = anchorPos.y - cameraPos.y
        let dz = anchorPos.z - cameraPos.z
        let distance = max(0.05, sqrtf(dx*dx + dy*dy + dz*dz))
        // Simple heuristic: scale grows linearly with distance
        // Base tuned so that at 0.35m, size is ~targetVisualSizeMeters
        let baseDistance: Float = 0.35
        let baseScale: Float = targetVisualSizeMeters / baseDistance
        let scaleValue = baseScale * distance
        anchor.scale = SIMD3<Float>(repeating: scaleValue)
    }
    
    private func setDetectionState(detected: Bool) {
        guard detected != isWristDetected else { return }
        isWristDetected = detected
        DispatchQueue.main.async {
            self.loadingOverlay.layer.removeAllAnimations()
            if detected {
                // Fade out overlay
                self.loadingOverlay.isHidden = false
                UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                    self.loadingOverlay.alpha = 0
                } completion: { _ in
                    self.loadingOverlay.isHidden = true
                    self.view.sendSubviewToBack(self.loadingOverlay)
                    self.setWatchVisible(true, animated: true)
                }
            } else {
                // Fade in overlay and remove watch from scene until we detect again
                self.loadingOverlay.isHidden = false
                self.lastWristTransform = nil
                if self.loadingOverlay.alpha < 1 { self.loadingOverlay.alpha = 0 }
                UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                    self.loadingOverlay.alpha = 1
                }
                self.setWatchVisible(false, animated: true)
            }
        }
    }

    // Keep for safety but new helper supersedes this
    private func ensureWatchAnchorVisible(_ visible: Bool) {
        guard let anchor = watchAnchor else { return }
        if visible {
            if anchor.parent == nil { arView.scene.addAnchor(anchor) }
        } else {
            if anchor.parent != nil { arView.scene.anchors.remove(anchor) }
        }
    }

    // MARK: - Visibility helpers
    private func setWatchVisible(_ visible: Bool, animated: Bool = true, duration: TimeInterval = 0.22) {
        guard let anchor = watchAnchor else { return }
        // Ensure we have a model entity to fade
        let model = anchor.children.compactMap { $0 as? ModelEntity }.first
        let applyAlpha: (Float) -> Void = { alpha in
            if let model = model {
                // Prefer OpacityComponent when available
                if model.components.has(OpacityComponent.self) {
                    model.components.set(OpacityComponent(opacity: alpha))
                } else {
                    // Fallback: update materials' base color alpha if SimpleMaterial
                    model.model?.materials = model.model?.materials.map { material in
                        if var simple = material as? SimpleMaterial {
                            var color = simple.color
                            color.tint = color.tint.withAlphaComponent(CGFloat(alpha))
                            simple.color = color
                            return simple
                        }
                        return material
                    } ?? []
                }
            }
        }
        if visible {
            if anchor.parent == nil { arView.scene.addAnchor(anchor) }
            if animated {
                applyAlpha(0)
                // Animate to 1
                UIView.animate(withDuration: duration) { applyAlpha(1) }
            } else {
                applyAlpha(1)
            }
        } else {
            let removeAnchor = { [weak self] in
                guard let self = self else { return }
                if anchor.parent != nil { self.arView.scene.anchors.remove(anchor) }
            }
            if animated {
                UIView.animate(withDuration: duration, animations: { applyAlpha(0) }) { _ in
                    removeAnchor()
                }
            } else {
                applyAlpha(0)
                removeAnchor()
            }
        }
    }
    
    private func applyWatchColor(_ uiColor: UIColor) {
        guard let root = self.watchModelEntity else { return }

        func tintMaterials(in entity: Entity) {
            // Only tint the exact band entity by name (and its descendants)
            if let model = entity as? ModelEntity, entity.name == "MswjViAcFQPAHRi" {
                var newMaterials: [Material] = []
                for material in (model.model?.materials ?? []) {
                    if var simple = material as? SimpleMaterial {
                        var color = simple.color
                        color.tint = uiColor
                        simple.color = color
                        newMaterials.append(simple)
                    } else if var pbr = material as? PhysicallyBasedMaterial {
                        var base = pbr.baseColor
                        base.tint = uiColor
                        pbr.baseColor = base
                        newMaterials.append(pbr)
                    } else {
                        newMaterials.append(material)
                    }
                }
                if !newMaterials.isEmpty {
                    model.model?.materials = newMaterials
                }
            }
            for child in entity.children { tintMaterials(in: child) }
        }

        tintMaterials(in: root)
    }
}

