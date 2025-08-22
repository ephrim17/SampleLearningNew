//  HomePage.swift
//  sample
//
//  Created by ephrim.daniel on 21/08/25.
//

import SwiftUI

struct HomePage: View {
    
    @State var goToCart = false
    @State var selected : Int = 0
    
    var columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
                ShopListView(type: .Fruits)
            } else {
                ShopListView(type: .Veggies)
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
            Button {
                goToCart = true
            } label: {
                Label("", systemImage: "bag")
            }
        }
        .navigationDestination(isPresented: $goToCart) {
            CartPage()
        }
    }
}


#Preview {
    NavigationStack {
        HomePage()
    }
}
