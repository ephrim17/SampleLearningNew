/*
 See the LICENSE.txt file for this sample’s licensing information.
 
 Abstract:
 Displays the camera for the document reader app.
 */

import SwiftUI
import FoundationModels

struct DocumentContentView: View {
    @State private var camera = Camera()
    @State var imageData: Data? = nil
    
    var body: some View {
        //        if let image = imageData {
        //            ImageView(imageData: image)
        //        } else {
        //            CameraView(camera: camera, imageData: $imageData)
        //                .task {
        //                    // Start the capture pipeline.
        //                    await camera.start()
        //                }
        //        }
        VStack {
            if let image = imageData {
                ImageView(imageData: image)
            }
        }
        .onAppear {
            convertAssetImageToData(named: "IMG_0038")
        }
    }
    
    func convertAssetImageToData(named name: String) {
        // 1. Get the UIImage from the asset catalog.
        guard let uiImage = UIImage(named: name) else {
            print("Error: Could not find image named \(name) in assets.")
            return
        }
        
        // 2. Convert the UIImage to Data.
        // Use .pngData() for lossless compression.
        // Use .jpegData(compressionQuality:) to specify a quality level.
        imageData = uiImage.pngData()
    }
}

#Preview {
    DocumentContentView()
}

import Playgrounds

#Playground {
    
    let session = LanguageModelSession()
    let response = try await session.respond(to: "Tell me about orange fruit")
}
