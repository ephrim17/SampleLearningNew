//
//  OnBoardingPage.swift
//  sample
//
//  Created by ephrim.daniel on 21/08/25.
//

import SwiftUI

struct OnBoardingPage: View {
    @State var changeScreen = false
    @AppStorage("isOnBoarded") var isOnBoarded: Bool = false
    
    var body: some View {
        VStack(spacing: 50) {
            Image("avocado")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            Text("We deliver\n grocery at your\n doorstep")
                .modifier(TextViewModifierForFruitSeller(fontSize: 42))
                .multilineTextAlignment(.center)
            Text("Grocerr gives you fresh vegetables and fruits,\nOrder fresh at grocerr")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            Button() {
                changeScreen = true
                isOnBoarded = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                    Text("Get Started")
                        .foregroundColor(.white)
                        .bold()
                }
            }.frame(width: 200, height: 70)
                .foregroundColor(.purple)
        }
        .navigationDestination(isPresented: $changeScreen) {
            Fruits_Seller()
        }
    }
}

