//
//  3DModelView.swift
//  sample
//
//  Created by ephrim.daniel on 09/12/25.
//

import SwiftUI
import RealityKit

struct ArModelView: View {
    // ... (Your @State variables remain the same) ...
    @State private var selectedEntityName: String?
    @State private var showTextView: Bool = true
    @State private var messageText: String? = "**Camera Control button**: Instantly take a photo, record video, adjust settings, and more. So you never miss a moment."
    let targetEntityName = "sQTUClhbUNPPGgI"
    
    @State private var modelEntity: ModelEntity?
    @State private var baseScale: Float = 0.1
    @State private var currentScale: Float = 0.1
    @State private var baseTranslation: SIMD3<Float> = .zero
    @State private var currentTranslation: SIMD3<Float> = SIMD3<Float>(-0.03866667, 0.298, 0.0)
    @State private var rotationX: Float = 0.0
    @State private var rotationY: Float = 0.0
    @State private var rotationZ: Float = 0.0

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button("Close") {
                        dismiss()
                    }
                }.padding(20)
                RealityView { content in
                    // Load your 3D model
                    if self.modelEntity == nil, let loaded = try? await ModelEntity(named: "iphone16.usdz") {
                        
                        
                        // Add InputTargetComponent only (Collision shapes generated recursively below)
                        if let powerButton = loaded.findEntity(named: targetEntityName) {
                            // 1. Add InputTargetComponent to make it interactable
                            powerButton.components.set(InputTargetComponent())
                            
                            // 2. Generate Collision Shapes if they aren't already there
                            // This is crucial for hit-testing to work
                            if powerButton.components[CollisionComponent.self] == nil {
                                powerButton.generateCollisionShapes(recursive: true)
                            }
                        }
                        
                        // Generate collision shapes for the entire model once
                        loaded.generateCollisionShapes(recursive: true)
                        self.modelEntity = loaded
                        content.add(loaded)
                        
                        print("--- Starting Entity List ---")
                                           listAllEntityNames(for: loaded)
                                           print("--- End of Entity List ---")
                        
                        
                    }
                    self.applyTransform()
                }
            }
                
            
            .gesture(
                TapGesture()
                    .targetedToAnyEntity()
                    .onEnded { value in
                        let tappedName = value.entity.name
                        selectedEntityName = tappedName
                        if tappedName == targetEntityName {
                            messageText = messageText
                        } else {
                            messageText = nil
                        }
                        showTextView = true
                    }
            )
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        let newScale = baseScale * Float(value)
                        currentScale = max(0.1, min(newScale, 10.0))
                        applyTransform()
                    }
                    .onEnded { _ in
                        baseScale = currentScale
                    }
            )
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        let factor: Float = 0.002
                        let dx = Float(value.translation.width) * factor
                        let dy = Float(value.translation.height) * factor
                        currentTranslation = SIMD3<Float>(baseTranslation.x + dx, baseTranslation.y - dy, baseTranslation.z)
                        applyTransform()
                    }
                    .onEnded { _ in
                        baseTranslation = currentTranslation
                    }
            )
            
            // ... (Your existing SwiftUI overlay views remain the same) ...
            if showTextView, let name = selectedEntityName, let messageTextPart = messageText {
//                VStack {
//                    Text(messageText ?? "Details for \(name)")
//                        .font(.headline)
//                        .padding()
//                    Button("Close") {
//                        showTextView = false
//                        selectedEntityName = nil
//                    }
//                    .padding()
//                }
                ProductCalloutView(isPresented: $showTextView, message: messageTextPart)
                .frame(width: 300, height: 200)
                .padding(.top, 50)
            }
            // ... (Your existing Vstack for Sliders remains the same) ...
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Text("Rotation")
                        .font(.headline)
                    HStack {
                        Text("X")
                        Slider(value: Binding(
                            get: { Double(rotationX) },
                            set: { rotationX = Float($0); applyTransform() }
                        ), in: -Double.pi ... Double.pi)
                    }
                    HStack {
                        Text("Y")
                        Slider(value: Binding(
                            get: { Double(rotationY) },
                            set: { rotationY = Float($0); applyTransform() }
                        ), in: -Double.pi ... Double.pi)
                    }
                    HStack {
                        Text("Z")
                        Slider(value: Binding(
                            get: { Double(rotationZ) },
                            set: { rotationZ = Float($0); applyTransform() }
                        ), in: -Double.pi ... Double.pi)
                    }
                }
                .padding(12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
            }
        }
    }
    
    // ... (Your existing applyTransform() function remains the same) ...
    private func applyTransform() {
        guard let entity = modelEntity else { return }
        let qx = simd_quatf(angle: rotationX, axis: SIMD3<Float>(1, 0, 0))
        let qy = simd_quatf(angle: rotationY, axis: SIMD3<Float>(0, 1, 0))
        let qz = simd_quatf(angle: rotationZ, axis: SIMD3<Float>(0, 0, 1))
        let rotation = qz * qy * qx

        var transform = Transform(scale: [currentScale, currentScale, currentScale], rotation: rotation, translation: currentTranslation)
        entity.transform = transform
    }
    
    func listAllEntityNames(for entity: Entity, indent: String = "") {
        print("\(indent)Entity Name: \(entity.name)")
        
        // Iterate over all child entities and call the function recursively
        for child in entity.children {
            listAllEntityNames(for: child, indent: indent + "  ")
        }
    }
}
