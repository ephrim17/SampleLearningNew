//
//  TextViewModifier.swift
//  sample
//
//  Created by ephrim.daniel on 21/08/25.
//

import SwiftUI

struct TextViewModifierForFruitSeller: ViewModifier {
   
    /// Applies a custom font style to the text content.
    var fontSize: CGFloat = 14
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: .medium, design: .default))
            .foregroundColor(.primary)
    }
}
