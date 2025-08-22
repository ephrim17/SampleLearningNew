//
//  WelcomeView.swift
//  sample
//
//  Created by ephrim.daniel on 21/08/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Welcome Back....")
                .foregroundColor(.blue)
                .modifier(TextViewModifierForFruitSeller(fontSize: 25))
            HStack(spacing: 0) {
                Text("Here are some ")
                    .foregroundColor(.black)
                    .font(.system(size: 23, weight: .semibold, design: .rounded))
                Text("\"Fresh\"")
                    .foregroundColor(.green)
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                
            }
            Text("items for you")
                .font(.system(size: 23, weight: .semibold, design: .rounded))
        }
    }
}

#Preview {
    WelcomeView()
}


struct ss: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("This is ")
                .foregroundColor(.black)
            Text("blue text.")
                .foregroundColor(.blue)
        }
    }
}
