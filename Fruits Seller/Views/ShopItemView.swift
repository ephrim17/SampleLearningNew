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
    
    var onAddToCart: (() -> Void)? = nil
    
    @State var showAddIcon: Bool = false
    @Namespace private var namespace
    
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
                        cartItems.append(title)
                        onAddToCart?()
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
    var imageUrl: URL?
    private let size: CGFloat = 120

    var body: some View {
        AsyncImage(url: imageUrl) { phase in
            Group {
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable().scaledToFit()
                case .failure(_):
                    Text("image failed")
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                @unknown default:
                    Text("Unknown state")
                }
            }
            .frame(width: size, height: size)
        }
    }
}
