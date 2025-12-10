//
//  ArModel_Rocket.swift
//  sample
//
//  Created by ephrim.daniel on 09/12/25.

import SwiftUI
import RealityKit

struct ArModelViewRocket: View {
    // ... (Your @State variables remain the same) ...
    @State private var selectedEntityName: String?
    @State private var showTextView: Bool = true
    @State private var messageText: String? = "click to know more about power button info"
    let targetEntityName = "TransformNew1" //"sQTUClhbUNPPGgI"
    
    @State private var modelEntity: Entity?
    @State private var baseScale: Float = 6.74
    @State private var currentScale: Float = 6.74
    @State private var baseTranslation: SIMD3<Float> = .zero
    @State private var currentTranslation: SIMD3<Float> = SIMD3<Float>(0.0106666675, -0.40133336, 0.0) //SIMD3<Float>(-0.03866667, 0.298, 0.0)
    @State private var rotationX: Float = 0.0
    @State private var rotationY: Float = 0.0
    @State private var rotationZ: Float = 0.0

    var body: some View {
        ZStack {
            RealityView { content in
                // 1. Load the main scene file that contains all entities
                guard let scene = try? await Entity.load(named: "rocket.usdz") else {
                    print("Failed to load rocket.usdz scene.")
                    return
                }
                
                // 2. Add the complete loaded scene to the content
                content.add(scene)
                self.modelEntity = scene

                // 3. Find your specific target entity and configure it for interaction
                if let targetAnchor = scene.findEntity(named: targetEntityName) {
                    
                    // CRITICAL STEP A: Mark this entity as interactable
                    targetAnchor.components.set(InputTargetComponent())
                    
                    // CRITICAL STEP B: Ensure it has collision geometry
                    // Generating shapes recursively on this specific anchor is best practice
                    targetAnchor.generateCollisionShapes(recursive: true)
                    
                    print("Successfully configured \(targetEntityName) for interaction.")

                } else {
                    print("Error: Could not find \(targetEntityName). Check the name for typos.")
                }
                
                // Optional: Ensure the whole model has collision shapes just in case
                // scene.generateCollisionShapes(recursive: true)
                self.applyTransform()
            }
            .gesture(
                TapGesture()
                    .targetedToAnyEntity()
                    .onEnded { value in
                        print("TAPPED ENTITY: \(value.entity.name)")
                        let tappedName = value.entity.name
                        selectedEntityName = tappedName
                        if tappedName == targetEntityName {
                            messageText = "click to know more about power button info"
                        } else {
                            messageText = nil
                        }
                        showTextView = true
                    }
            )
//            .simultaneousGesture(
//                MagnificationGesture()
//                    .onChanged { value in
//                        let newScale = baseScale * Float(value)
//                        currentScale = max(0.1, min(newScale, 10.0))
//                        applyTransform()
//                    }
//                    .onEnded { _ in
//                        baseScale = currentScale
//                    }
//            )
//            .simultaneousGesture(
//                DragGesture()
//                    .onChanged { value in
//                        let factor: Float = 0.002
//                        let dx = Float(value.translation.width) * factor
//                        let dy = Float(value.translation.height) * factor
//                        currentTranslation = SIMD3<Float>(baseTranslation.x + dx, baseTranslation.y - dy, baseTranslation.z)
//                        applyTransform()
//                    }
//                    .onEnded { _ in
//                        baseTranslation = currentTranslation
//                    }
//            )
            
            // ... (Your existing SwiftUI overlay views remain the same) ...
            if showTextView, let name = selectedEntityName {
                VStack {
                    Text(messageText ?? "Details for \(name)")
                        .font(.headline)
                        .padding()
                    Button("Close") {
                        showTextView = false
                        selectedEntityName = nil
                    }
                    .padding()
                }
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


import SwiftUI
import RealityKit

struct ArModelViewTest: View {
    // ... (rest of your state variables) ...
    @State private var modelEntity: ModelEntity?

    var body: some View {
        RealityView { content in
            // Use 'Entity.load(named: ...)' to load the whole scene container,
            // which often contains the Root entity.
            if let scene = try? await Entity.load(named: "rocket.usdz") {
            
                // Now call the function on the highest level entity loaded
                print("--- Starting Entity List ---")
                listAllEntityNames(for: scene) // This should now find Root and BlackScope
                print("--- End of Entity List ---")

                // Keep a reference to the main scene if needed for gestures/transforms
                //self.modelEntity = scene
                content.add(scene)

                // You can still find specific components within that scene hierarchy:
                if let blackScopeAnchor = scene.findEntity(named: "BlackScope") {
                   print("Successfully found the BlackScope anchor!")
                   // Use the anchor here...
                }
                
            } else {
                print("Failed to load the main scene file.")
            }
        }
        // ... (rest of your gestures/view) ...
    }
    
    func listAllEntityNames(for entity: Entity, indent: String = "") {
        print("\(indent)Entity Name: \(entity.name)")
        
        // Iterate over all child entities and call the function recursively
        for child in entity.children {
            listAllEntityNames(for: child, indent: indent + "  ")
        }
    }
    // ... (rest of your code and listAllEntityNames function) ...
}


import SwiftUI
import RealityKit
import ARKit

struct FixedArModelView: View {
    @State private var selectedEntityName: String?
    @State private var showTextView: Bool = false
    @State private var messageText: String? = nil
    
    // Use the name identified in your console output
    let targetEntityName = "TransformNew"
    
    @State private var modelEntity: Entity? // Changed to Entity? as advised previously

    var body: some View {
        ZStack {
            RealityView { content in
                // 1. Load the main scene file that contains all entities
                guard let scene = try? await Entity.load(named: "rocket.usdz") else {
                    print("Failed to load rocket.usdz scene.")
                    return
                }
                
                // 2. Add the complete loaded scene to the content
                content.add(scene)
                self.modelEntity = scene

                // 3. Find your specific target entity and configure it for interaction
                if let targetAnchor = scene.findEntity(named: targetEntityName) {
                    
                    // CRITICAL STEP A: Mark this entity as interactable
                    targetAnchor.components.set(InputTargetComponent())
                    
                    // CRITICAL STEP B: Ensure it has collision geometry
                    // Generating shapes recursively on this specific anchor is best practice
                    targetAnchor.generateCollisionShapes(recursive: true)
                    
                    print("Successfully configured \(targetEntityName) for interaction.")

                } else {
                    print("Error: Could not find \(targetEntityName). Check the name for typos.")
                }
                
                // Optional: Ensure the whole model has collision shapes just in case
                // scene.generateCollisionShapes(recursive: true)
            }
            .gesture(
                TapGesture()
                    .targetedToAnyEntity()
                    .onEnded { value in
                        let tappedName = value.entity.name
                        
                        // This condition should now successfully detect the tap
                        if tappedName == targetEntityName {
                            selectedEntityName = tappedName
                            messageText = "Click to know more about power button info (or black circle)."
                            showTextView = true
                        }
                    }
            )
            // ... (Add your other gestures here, ensuring they are simultaneous or prioritized correctly) ...
            
            // ... (Your existing SwiftUI overlay views go here) ...
            if showTextView, let name = selectedEntityName {
                 // ... overlay UI code ...
            }
            // ... (Your existing Sliders UI) ...
        }
    }
    // ... (Your applyTransform function) ...
}

