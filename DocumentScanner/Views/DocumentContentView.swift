/*
 See the LICENSE.txt file for this sample’s licensing information.
 
 Abstract:
 Displays the camera for the document reader app.
 */

import SwiftUI
import FoundationModels
internal import Combine

class ImageDataModel: ObservableObject {
    /// The first table detected in the document.
    @Published var imageData: Data? = nil
    
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
    
    func resetImageData() {
        imageData = nil
    }
    
}

struct DocumentContentView: View {
    @State private var camera = Camera()
    @State var imageData: Data? = nil
    @EnvironmentObject var imageDataViewModel: ImageDataModel
    @EnvironmentObject var visionModel: VisionModel
    @State private var isInitialized = false
    @EnvironmentObject var router: Router
    
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
        ZStack {
            // subtle background
            Image("scannerBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack{
                VStack {
                    if let imageData = imageDataViewModel.imageData {
                        ImageView(imageData: imageData)
                            .transition(.opacity)
                    }
                }
            }
        }
        .onAppear {
            if !isInitialized {
                imageDataViewModel.resetImageData()
                visionModel.resetState()
                isInitialized = true
                //var imageName = "Hotel-invoice-example1"
                var imageName = "11Grocery"
                imageDataViewModel.convertAssetImageToData(named: imageName)
            }
        }
        .onDisappear {
            imageData = nil
            isInitialized = false
            // Ensure vision model is reset when leaving
            visionModel.resetState()
            imageDataViewModel.resetImageData()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    router.reset()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
    
}


#Preview {
    DocumentContentView()
}
