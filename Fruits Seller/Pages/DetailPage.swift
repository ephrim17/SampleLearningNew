//
//  DetailPage.swift
//  sample
//
//  Created by ephrim.daniel on 22/08/25.
//

//
//  GeometryEffectView.swift
//  SampleApp_SwiftUI
//
//  Created by ephrim.daniel on 29/01/25.
//

import SwiftUI

struct ToastView: View {
    let message: String
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical)
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
            .modifier(TextViewModifierForFruitSeller(fontSize: 12))
    }
}

struct DetailPage: View {
    @Namespace var animation
    @State var detailViewName: String? = nil
    @State var selectedItem: PROduceModel? = nil
    
    @State var showDetail: Bool = false
    @State var showAddToCart: Bool = false
    @State private var showToast = false
    
    var body: some View {
        ZStack {
            Color(hex: selectedItem?.color ?? "#FFFFFF").ignoresSafeArea()
                .opacity(0.25)
            VStack (spacing: 10){
                
                if let proItem = selectedItem {
                    ShopItemImage(imageUrl: URL(string: proItem.image), width: 300, height: 300)
                    if showDetail{
                        Text("Here's the salad that you can try with \(proItem.name)")
                            .modifier(TextViewModifierForFruitSeller(fontSize: 18))
                        AFMSaladGeneratorView(selectedFruits: [proItem.image])
                        if showAddToCart {
                            
                            Button {
                                cartItems.append(proItem.name)
                                showToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    showToast = false
                                }
                            } label: {
                                ZStack{
                                    Text("Add to Cart")
                                        .foregroundColor(Color.primary)
                                    //.fontWeight(.bold)
                                        .modifier(TextViewModifierForFruitSeller())
                                        .padding(10)
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(15)
                                .padding()
                            }
                        } else {
                            VStack {
                                LoadingDotsView()
                                    .foregroundColor(.primary)
                                Text("Apple Intelligence loading...")
                                    .foregroundColor(.primary)
                                    .padding(.top, 10)
                                    .modifier(TextViewModifierForFruitSeller())
                            }
                        }
                    }
                }
                Spacer()
            }
            .onPreferenceChange(ShopImagePreferenceKey.self) { value in
                showDetail = value
            }
            
            .onPreferenceChange(ShopAddToCartKey.self) { value in
                showAddToCart = value
            }
            
            
            
            if showToast {
                VStack {
                    Spacer()
                    ToastView(message: "Item added to cart!")
                        .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: showToast)
            }
        }
    }
}


#Preview {
    //NavigationStack {
    
    DetailPage(selectedItem: PROduceModel(name: "Apple", image: "https://png.pngtree.com/png-vector/20231017/ourmid/pngtree-fresh-apple-fruit-red-png-image_10203073.png", id: 1, color: "#FF0000", rating: "4.5", description: "A crisp, sweet apple.", offer: "10% off", price: "$2.99"))
    
    //}
}


import SwiftUI

struct LoadingDotsView: View {
    @State private var animating: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .scaleEffect(animating ? 1.2 : 1.0)
                    .opacity(animating ? 0.5 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: animating
                    )
            }
        }
        .onAppear {
            animating = true
        }
    }
}
