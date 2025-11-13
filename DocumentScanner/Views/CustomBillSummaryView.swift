//
//  CustomBillSummaryView.swift
//  sample
//
//  Created by ephrim.daniel on 13/11/25.
//

import SwiftUI

struct CustomBillSummaryView: View {
    var invoiceMakerItems: InvoiceMakerModel

    private let columns: [GridItem] = [
        GridItem(.flexible(minimum: 60), alignment: .leading),
        GridItem(.flexible(minimum: 80), alignment: .leading),
        GridItem(.flexible(minimum: 120), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading)
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Bills")
                    .font(.title2).bold()
                    .padding(.top, 8)

                // Header row
                LazyVGrid(columns: columns, spacing: 12) {
                    Text("Date").font(.headline)
                    Text("Person Name").font(.headline)
                    Text("Address").font(.headline)
                    Text("Total Amount").font(.headline)
                }
                .padding(.vertical, 8)

                Divider()

                // Data row
                LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                    Text(invoiceMakerItems.Date)
                        .font(.body)
                    Text(invoiceMakerItems.personName)
                        .font(.body)
                    Text(invoiceMakerItems.address)
                        .font(.body)
                    Text(invoiceMakerItems.totalAmount)
                        .font(.body)
                    
                    
                }

                Spacer(minLength: 0)
            }
            .frame(minWidth: 600, alignment: .leading)
            .padding()
        }
        .navigationTitle("Summary")
    }
}
