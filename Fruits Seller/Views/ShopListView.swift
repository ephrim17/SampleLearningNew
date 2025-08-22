//
//  ShopListView.swift
//  sample
//
//  Created by ephrim.daniel on 21/08/25.
//

import SwiftUI

struct ShopListView: View {
    @State var type: SaladType
    @State var goToDetail = false
    @State var selectedItem: PROduceModel? = nil
    @ObservedObject var viewModel = PROduceViewModel()
    
    @Namespace private var namespace
    
    var columns = [
        GridItem(.fixed(180)),
        GridItem(.fixed(180)),
    ]
    
    var onAddToCart: (() -> Void)? = nil
    
    var body: some View {
        ScrollView() {
            LazyVGrid(columns: columns, spacing: 20) {
                if let items = viewModel.items {
                    ForEach(items, id: \.id) { item in
                        ShopItem(imageName: item.image, title: item.name, color: item.color, rating: item.rating, desc: item.description, offer: item.offer, price: item.price, onAddToCart: onAddToCart)
                            .matchedGeometryEffect(id: item.id, in: namespace)
                            .onTapGesture {
                                goToDetail = true
                                selectedItem = item
                            }
                    }
                }
            }
        }
        .padding(15)
        .onAppear {
            viewModel.loadItems(type: type)
        }
        .navigationDestination(isPresented: $goToDetail) {
            DetailPage(selectedItem: selectedItem)
                .navigationTransition(.zoom(sourceID: selectedItem, in: namespace))
            
        }
    }
}

