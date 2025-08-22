//
//  CartPage.swift
//  sample
//
//  Created by ephrim.daniel on 21/08/25.
//

import SwiftUI

var cartItems: [String] = []

struct CartPage: View {
    
    @State var totalPrice = 0.00
    
    var body: some View {
        VStack {
            Text("My Cart")
                .modifier(TextViewModifierForFruitSeller(fontSize: 28))
                .frame(width: 320)
            List {
                ForEach(cartItems, id:\.self) {item in
                    HStack {
                        VStack(spacing: 5) {
                            Text(item)
                            .modifier(TextViewModifierForFruitSeller(fontSize: 18))                        }
                    }
                }.onDelete{indexSet in
                    cartItems.remove(atOffsets: indexSet)
                }
            }
            Spacer()
            
        }
    }
}

struct Cart_Previews: PreviewProvider {
    static var previews: some View {
        CartPage()
    }
}

