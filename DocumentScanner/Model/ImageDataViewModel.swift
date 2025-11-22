//
//  ImageDataViewModel.swift
//  sample
//
//  Created by ephrim.daniel on 22/11/25.
//

import Foundation
import SwiftUI
import FoundationModels
internal import Combine

class ImageDataViewModel: ObservableObject {
    @Published var imageData: Data? = nil
    
    func convertAssetImageToData(named name: String) {
        guard let uiImage = UIImage(named: name) else {
            print("Error: Could not find image named \(name) in assets.")
            return
        }
        imageData = uiImage.pngData()
    }
    
    func resetImageData() {
        imageData = nil
    }
}
