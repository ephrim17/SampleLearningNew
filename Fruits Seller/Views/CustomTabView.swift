//
//  CustomSwitch.swift
//  sample
//
//  Created by ephrim.daniel on 21/08/25.
//

import SwiftUI

struct CustomSwitch: View {
    
    @Binding var selected: Int
    
    var body: some View {
        HStack(spacing: -5){
            Button {
                self.selected = 0
            } label: {
                Text("Fruits")
                    .frame(height: 10)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
                    .background(selected == 0 ? Color.white : Color.gray.opacity(0.0))
                    .clipShape(Capsule())
                    .modifier(TextViewModifierForFruitSeller())
            }
            .padding(4)
            .foregroundColor(selected == 0 ? .black : .white)
            
            Button {
                self.selected = 1
            } label: {
                Text("Veggies")
                    .frame(height: 10)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
                    .background(selected == 1 ? Color.white : Color.gray.opacity(0.0))
                    .clipShape( Capsule())
                    .modifier(TextViewModifierForFruitSeller())
            }
            .padding(4)
            .foregroundColor(selected == 1 ? .black : .white)
        }
    }
}

#Preview {
    HomePage()
}
