//
//  ProductCalloutView.swift
//  sample
//
//  Created by ephrim.daniel on 10/12/25.
//

import SwiftUI

struct ProductCalloutView: View {
    // Binding to a Boolean value in the parent view to control visibility
    @Binding var isPresented: Bool
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AttributedTextView()
                .font(.caption)
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 0))

            Button(action: {
                // Dismiss the callout by setting the binding to false
                withAnimation(.easeOut) {
                    isPresented = false
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 8))
            .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to avoid default button styling
        }
        .background(Color.secondary)
        .cornerRadius(10)
        .shadow(radius: 5)
        .transition(.scale) // Add a transition effect when showing/hiding
    }
}


import SwiftUI
import Foundation // Required for AttributedString

struct AttributedTextView: View {
    var body: some View {
        Text(formattedText)
            //.padding()
    }
    
    var formattedText: AttributedString {
        var attributedString = AttributedString("Camera Control button: Instantly take a photo, record video, adjust settings, and more. So you never miss a moment.")

        // Find and apply attributes to specific ranges
        if let boldRange = attributedString.range(of: "Camera Control button") {
            attributedString[boldRange].font = .boldSystemFont(ofSize: 17)
        }
        
//        if let linkRange = attributedString.range(of: "this part is a link") {
//            attributedString[linkRange].link = URL(string: "https://www.apple.com")
//            // SwiftUI automatically styles links with the system tint color
//        }
//
//        if let largeTextRange = attributedString.range(of: "this is large text") {
//            attributedString[largeTextRange].font = .systemFont(ofSize: 23)
//        }

        return attributedString
    }
}
