//  HomePage.swift
//  sample
//
//  Created by ephrim.daniel on 21/08/25.
//

import SwiftUI

struct HomePage: View {
    
    @State var goToCart = false
    @State var selected : Int = 0
    @State private var showToast = false
    
    var columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func handleAddToCart() {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showToast = false
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            WelcomeView()
                .padding(10)
            HStack (alignment: .center){
                Spacer()
                CustomSwitch(selected: $selected)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Capsule())
                Spacer()
            }
            
            if selected == 0 {
                ShopListView(type: .Fruits, onAddToCart: handleAddToCart)
            } else {
                ShopListView(type: .Veggies, onAddToCart: handleAddToCart)
            }
            
            HStack (alignment: .center){
                Spacer()
                AFMButton()
                    .opacity(0.8)
                Spacer()
            }
            
            Spacer()
        }
        .toolbar {
            ToolBarButton(goToCart: $goToCart, showToast: $showToast)
        }
        .navigationDestination(isPresented: $goToCart) {
            CartPage()
        }
    }
}

// This view is intended to be used inside a '.toolbar' modifier in a parent view.
struct ToolBarButton: View {
    
    @Binding var goToCart: Bool
    @Binding var showToast: Bool
    
    var body: some View {
        Button {
            goToCart = true
        } label: {
            if showToast {
                Text("Added to Cart")
                    .scaleEffect(0.8)
                    .animation(.easeInOut(duration: 0.2), value: showToast)
            } else {
                Label("", systemImage: "bag")
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        HomePage()
    }
}
