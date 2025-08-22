//  ShopItem.swift
//  sample
//
//  Created by ephrim.daniel on 21/08/25.
//

import SwiftUI

struct ShopItem: View {
    
    var imageName: String
    var title: String
    var color: String
    
    var rating: String
    var desc: String
    var offer:String
    var price: String
    
    @State var showAddIcon: Bool = false
    @Namespace private var namespace
    
    @State private var showToast = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color(hex: color))
                .opacity(0.25)
                .frame(width: 170, height: 280)
            VStack {
                ShopItemImage(imageUrl: URL(string: imageName))
                if showAddIcon {
                    HStack {
                        VStack (alignment: .leading, spacing: 5) {
                            Text(title)
                                .font(.headline)
                            Text(desc)
                                .modifier(TextViewModifierForFruitSeller(fontSize: 8))
                                
                            Text(offer)
                                .modifier(TextViewModifierForFruitSeller(fontSize: 12))
                            HStack(alignment: .center, spacing: 2) {
                                Text(rating)
                                    .modifier(TextViewModifierForFruitSeller(fontSize: 12))
                                Text("⭐️⭐️⭐️⭐️")
                                    .modifier(TextViewModifierForFruitSeller(fontSize: 12))
                            }
                            
                        }
                        Spacer()
                    }.padding(.leading, 10)
                HStack{
                    Spacer()
                    Text(price)
                        .modifier(TextViewModifierForFruitSeller(fontSize: 13))
                    Button() {
                        //ADD Cart Items
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showToast = false
                        }
                        cartItems.append(title)
                    } label: {
                        
                            ZStack{
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color.white)
                                    .padding(4)
                                    
                            }.background(Color.gray.opacity(0.5))
                                .clipShape(Circle())
                        }
                    
                    }.padding(.trailing, 10)
                        .padding(.bottom, 10)
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
        .onPreferenceChange(ShopImagePreferenceKey.self) { value in
            showAddIcon = value
        }
    }
}

#Preview {
    HomePage()
}


struct ShopItemImage: View {
    @State var imageUrl = URL(string: "")
    @State var width: CGFloat = 120
    @State var height: CGFloat = 120

    var body: some View {
        AsyncImage(url: imageUrl) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .showShopImage(false)
            case .success(let image):
                image
                    .resizable()
                    .frame(width: width, height: height)
                    .scaledToFit()
                    .showShopImage(true)
            case .failure:
                Text("")
                    .frame(width: height, height: height)
                    .showShopImage(true)
            @unknown default:
                // Handle any future cases not yet defined in AsyncImagePhase
                Text("Unknown state")
            }
        }
    }
}

