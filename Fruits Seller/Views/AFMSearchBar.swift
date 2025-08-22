//
//  AFMSearchBar.swift
//  sample
//
//  Created by ephrim.daniel on 21/08/25.
//

import SwiftUI
internal import Combine

struct AFMSearchBar: View {
    
    @Binding var tempText: String
    @State var x: Int = 0
    
    @FocusState var isTextFieldFocused: Bool
    
    var gradientsPill: [Gradient] = [
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
    
    var gradientsKeyboard: [Gradient] = [
        Gradient(colors: [
            Color(hex: "#A0414B")!, // Further Darkened Pink
            Color(hex: "#A07749")!  // Further Darkened Yellow
        ]),
        Gradient(colors: [
            Color(hex: "#A07749")!, // Further Darkened Yellow
            Color(hex: "#5A6299")!  // Further Darkened Blue
        ]),
        Gradient(colors: [
            Color(hex: "#5A6299")!, // Further Darkened Blue
            Color(hex: "#9E7296")!  // Further Darkened White
        ]),
        Gradient(colors: [
            Color(hex: "#9E7296")!, // Further Darkened White
            Color(hex: "#A0414B")!  // Further Darkened Pink
        ])
    ]

    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            ZStack {
                ZStack {
                    ZStack {
                        HStack {
                            Image(systemName: "apple.intelligence")
                                .padding(.leading, 20)
                                //.brightness()
                            
                            Spacer()
                        }
                    }
                    TextField("Ask Apple Intelligence...", text: $tempText)
                        .padding(.leading, 30)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color(hex: "#483838")!
                                .opacity(0.2))
                                .brightness(0.5)
                        )
                        .focused($isTextFieldFocused)
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
                }.padding()
                .onReceive(timer) { _ in
                    x = (x + 1) % gradientsPill.count
                }
            }
        }
    }
}

#Preview {
    HomePage()
}


