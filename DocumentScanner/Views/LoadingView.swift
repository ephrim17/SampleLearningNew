//
//  LoadingView.swift
//  sample
//
//  Created by ephrim.daniel on 22/11/25.
//

import SwiftUI

struct LoadingOverlayView: View {
    
    var loadingText: String = "Loading..."
    
    var body: some View {
        ZStack {
            // A semi-transparent background that covers the whole screen
            if (!loadingText.isEmpty) {
                Color.black
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)

                // The loading indicator container (e.g., a blurred box)
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Text(loadingText)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
                .padding(25)
                .background(Color.black.opacity(0.7))
                .cornerRadius(15)
            }
            
        }
    }
}

