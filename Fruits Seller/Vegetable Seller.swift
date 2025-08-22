//  Vegetable Seller.swift
//  sample
//
//  Created by ephrim.daniel on 25/07/25.
//

import SwiftUI

struct Fruits_Seller: View {
    
    @ObservedObject var viewModel = PROduceViewModel()
    @State var selectedItems : [String] = []
    @State private var showModal = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        Spacer()
                        PROduceSelectionList(items: viewModel.items ?? [], selections: $selectedItems)
                        //Spacer()
                    }.padding()
                }
                
                if selectedItems.count > 0 {
                    Divider()
                    Button {
                        print("Selected Items: \(selectedItems)")
                    } label: {
                        Text("Add To Bag")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }.padding()
                    
                }
            }
            .navigationTitle("Vegetables To Buy")
            .toolbar {
                Button {
                    showModal = true
                } label: {
                    Label("", systemImage: "wand.and.sparkles")
                }
            }
        }
        .onAppear {
            viewModel.loadItems(type: .Veggies)
        }
        .sheet(isPresented: $showModal) {
            SuggestorChatMessageView()
        }
    }
}
