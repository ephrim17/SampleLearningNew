//
//  ViewModifiers.swift
//  sample
//
//  Created by ephrim.daniel on 22/11/25.
//

import SwiftUI

struct CustomTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
    }
}


struct RoundedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.headline)
            .background(Color.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}
