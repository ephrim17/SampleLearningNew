//  HomePage.swift
//  sample
//
//  Created by ephrim.daniel on 21/08/25.
//

import SwiftUI

struct HomePage: View {
    @State private var goToCart = false
    @State private var selected = 0
    @State private var showToast = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    private func handleAddToCart() {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showToast = false
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            WelcomeView().padding(10)
            HStack {
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
            FooterView()
            HStack {
                Spacer()
                AFMButton().opacity(0.8)
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
        .foregroundColor(showToast ? .blue : .primary)
    }
}

struct FooterView: View {
    var body: some View {
        Text("hello world footer")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1))
            .font(.footnote)
    }
}

#Preview {
    NavigationStack {
        HomePage()
    }
}
