//  WatchTryOnContainer.swift
//  sample
//
//  Created to embed ViewController (UIKit ARView) into SwiftUI.

import SwiftUI

struct WatchTryOnContainer: UIViewControllerRepresentable {
    

    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // No-op for now; update logic if needed
    }
}

// Usage in SwiftUI:
// struct ContentView: View {
//     var body: some View {
//         WatchTryOnContainer()
//             .edgesIgnoringSafeArea(.all) // (Optional)
//     }
// }
