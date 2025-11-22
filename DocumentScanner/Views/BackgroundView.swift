//
//  BackgroundView.swift
//  sample
//
//  Created by ephrim.daniel on 22/11/25.
//

import SwiftUI

struct BackgroundContainerView<Content: View>: View {
    let content: Content
    let backgroundImageName: String = "scannerBg"
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Background Layer: The shared background image
            Image(backgroundImageName)
                .resizable()
                .ignoresSafeArea()
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    BackgroundContainerView {
        ScannerAppHome()
    }
}
