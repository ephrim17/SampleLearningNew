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
    @State var hideActionButton: Bool = false
    
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
            if hideActionButton, let image = imageData {
                ImageView(imageData: image)
                    .transition(.opacity) 
            } else {
                Spacer()
                Text("Tap the button to add image.")
                    .font(.title)
                    .foregroundColor(.gray)
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        convertAssetImageToData(named: "Hotel-invoice-example1")
                        withAnimation(.easeInOut(duration: 0.25)) {
                            hideActionButton = true
                    }
                    }) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 70, height: 70)
                            .background(Color.black)
                            .clipShape(Circle())
                    }.padding()
                    
                                    }
            }
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
        hideActionButton = true
    }
}


#Preview {
    DocumentContentView()
}
