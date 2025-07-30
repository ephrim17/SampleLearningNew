//
//  SaladSelectorView.swift
//  sample
//
//  Created by ephrim.daniel on 15/07/25.
//

import SwiftUI

struct SaladSelectorView: View {
    
    var saladType: SaladType
    @ObservedObject var viewModel = PROduceViewModel()
    @State var selectedItems : [String]
    
    let columns = [
        GridItem(.adaptive(minimum: 200))
    ]
    
    var body: some View {
        ScrollView {
            VStack (alignment: .center){
                PROduceSelectionList(items: viewModel.items ?? [], selections: $selectedItems)
                if selectedItems.count > 0 {
                    Spacer()
                    NavigationLink {
                        AFMSaladGeneratorView(selectedFruits: selectedItems)
                    } label: {
                        Text("Generate Salad")
                    }
                }
            }.padding()
        }.onAppear {
            viewModel.loadItems(type: saladType)
        }
        .navigationTitle("Make your Salad From \(saladType.rawValue)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
