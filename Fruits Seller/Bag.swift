//  Bag.swift
//  sample
//
//  Created by ephrim.daniel on 25/07/25.
//

import SwiftUI

struct Bag: View {
    var selectedItems: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🛍️ Your Bag")
                .font(.largeTitle)
                .bold()
            if selectedItems.isEmpty {
                Text("Your bag is empty.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(selectedItems, id: \.self) { item in
                    Text("• \(item)")
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Bag")
    }
}

#Preview {
    Bag(selectedItems: ["Apple", "Banana"])
}
