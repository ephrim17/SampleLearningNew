//
//  SaladTypeView.swift
//  sample
//
//  Created by ephrim.daniel on 15/07/25.
//

import SwiftUI


struct SaladTypeView: View {
    @StateObject var viewModel = SaladTypeViewMdoel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List(viewModel.items ?? [], id: \.id) { salad in
                    NavigationLink(destination: SaladLinkHandler(saladType: salad.type)) {
                        Text(salad.type.rawValue)
                    }
                }
            }
            .navigationTitle("Make your Salad")
        }
        .onAppear {
            viewModel.loadItems()
        }
    }
}

#Preview {
    SaladTypeView()
}

struct SaladLinkHandler: View {
    
    var saladType: SaladType
    
    var body: some View {
        SaladSelectorView(saladType: saladType, selectedItems: [])
    }
}


