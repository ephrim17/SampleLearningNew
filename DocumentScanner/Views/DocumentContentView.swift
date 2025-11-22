/*
 See the LICENSE.txt file for this sample’s licensing information.
 
 Abstract:
 Displays the camera for the document reader app.
 */

import SwiftUI
import FoundationModels
internal import Combine

struct DocumentContentView: View {
    @State private var camera = Camera()
    @State var imageData: Data? = nil
    @EnvironmentObject var imageDataViewModel: ImageDataViewModel
    @EnvironmentObject var visionModel: VisionModel
    @State private var isInitialized = false
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
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
