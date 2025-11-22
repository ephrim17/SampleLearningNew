//
//  CustomBillSummaryView.swift
//  sample
//
//  Created by ephrim.daniel on 13/11/25.
//

import SwiftUI

struct CustomBillSummaryView: View {
    var invoiceMakerItems: [InvoiceMakerModel]
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var imageDataModel: ImageDataViewModel
    @EnvironmentObject var visionModel: VisionModel
    @State private var currentInvoices: [InvoiceMakerModel] = []
    
    var body: some View {
        ZStack {
            Image("scannerBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                VStack{
                    if currentInvoices.isEmpty {
                        Spacer()
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No Bills Yet")
                            .font(.title)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        Text("Upload a bill to get started")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(Array(currentInvoices.enumerated()), id: \.offset) { index, invoice in
                                    BillCard(invoice: invoice, index: index, onDelete: {
                                        deleteBillAndRefresh(at: index)
                                    }, onSave: { updatedInvoice in
                                        StorageManager.shared.updateInvoice(at: index, with: updatedInvoice)
                                        withAnimation {
                                            currentInvoices = StorageManager.shared.loadInvoices()
                                        }
                                    })
                                }
                            }.padding()
                        }
                    }
                    HStack {
                        HStack(spacing: 0) {
                            Button(action: {
                            }) {
                                Text("New Upload")
                                    .frame(maxWidth: .infinity)
                                    .font(.system(size: 20, weight: .semibold))
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                        HStack(spacing: 0) {
                            Button(action: {
                            }) {
                                Text("Sync")
                                    .frame(maxWidth: .infinity)
                                    .font(.system(size: 20, weight: .semibold))
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                    }.padding(20)
                }
            }.padding(.top, 40)
            .onAppear {
                currentInvoices = invoiceMakerItems
            }
        }
        .navigationTitle("Summary")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    router.reset()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
    private func deleteBillAndRefresh(at index: Int) {
        StorageManager.shared.deleteInvoice(at: index)
        withAnimation {
            currentInvoices = StorageManager.shared.loadInvoices()
        }
    }
}

#Preview {
    CustomBillSummaryView(invoiceMakerItems: [
        InvoiceMakerModel(Date: "aaaa", totalAmount: "aaaa", currencySymbol: "$", storeName: "default", address: "teron 104 BTM Bangalore, Kssssssssssssssssss Kssssssssssssssssss Kssssssssssssssssss Ksssssss sssssssssss ss www", personName: "aaaa")
    ])
}



