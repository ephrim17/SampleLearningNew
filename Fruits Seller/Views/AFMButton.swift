//
//  AFMButton.swift
//  sample
//
//  Created by ephrim.daniel on 21/08/25.
//

import SwiftUI
internal import Combine

struct AFMButton: View {
    
    @State var showAFMScreen = false
    @State private var x: Int = 0
    
    private var gradientsPill: [Gradient] = [
        Gradient(colors: [
            Color(hex: "#FF6778")!, // PINK
            Color(hex: "#FFBA71")!  // YELLOW
        ]),
        Gradient(colors: [
            Color(hex: "#FFBA71")!, // YELLOW
            Color(hex: "#8D99FF")!  // BLUE
        ]),
        Gradient(colors: [
            Color(hex: "#8D99FF")!, // BLUE
            Color(hex: "#F5B9EA")!  // WHITE
        ]),
        Gradient(colors: [
            Color(hex: "#F5B9EA")!, // WHITE
            Color(hex: "#FF6778")!  // PINK
        ])
    ]
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Button {
            showAFMScreen = true
        } label: {
            Text("Use Apple Intelligence")
                .modifier(TextViewModifierForFruitSeller())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(hex: "#483838")!
                .opacity(0.2))
                .brightness(0.5)
        )
        .foregroundColor(.black)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    LinearGradient(
                        gradient: gradientsPill[x],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 5
                ).blur(radius: 5)
                .animation(.smooth(duration: 4), value: x)
        )
        .shadow(color: Color.white.opacity(0.3), radius: 5)
        .onReceive(timer) { _ in
            x = (x + 1) % gradientsPill.count
        }
        .navigationDestination(isPresented: $showAFMScreen) {
            SuggestorChatMessageView()
        }

    }
}


#Preview {
    AFMButton()
}
