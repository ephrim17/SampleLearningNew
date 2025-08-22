//
//  PROduceSelectionList.swift
//  sample
//
//  Created by ephrim.daniel on 15/07/25.
//

import SwiftUI

struct PROduceSelectionList: View {
    var items: [PROduceModel]
    @Binding var selections : [String]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(self.items, id: \.id) { item in
                    PROduceSelectionRow(title: item.name, proItem: item, isSelected: self.selections.contains(item.name)) {
                        if self.selections.contains(item.name) {
                            self.selections.removeAll(where: { $0 == item.name })
                        }
                        else {
                            self.selections.append(item.name)
                        }
                    }
                }
            }
            
//            ForEach(self.items, id: \.id) { item in
//                PROduceSelectionRow(title: item.name, proItem: item, isSelected: self.selections.contains(item.name)) {
//                    if self.selections.contains(item.name) {
//                        self.selections.removeAll(where: { $0 == item.name })
//                    }
//                    else {
//                        self.selections.append(item.name)
//                    }
//                }
//            }
    }
}

struct PROduceSelectionRow: View {
    var title: String
    var proItem: PROduceModel
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                PROduceitemView(PROitem: proItem)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                } else {
                    Spacer()
                }
            }
        }
    }
}
