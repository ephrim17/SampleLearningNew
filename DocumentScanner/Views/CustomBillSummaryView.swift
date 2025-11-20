//
//  CustomBillSummaryView.swift
//  sample
//
//  Created by ephrim.daniel on 13/11/25.
//

import SwiftUI


struct BillAction: View {
    let icon: String?
    let foregroundColor: Color?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon ?? "")
                .font(.system(size: 32))
                .foregroundColor(foregroundColor)
            
        }
    }
}

struct CustomBillSummaryView: View {
    var invoiceMakerItems: [InvoiceMakerModel]

    @EnvironmentObject var router: Router
    @EnvironmentObject var imageDataModel: ImageDataModel
    @EnvironmentObject var visionModel: VisionModel
    @State private var currentInvoices: [InvoiceMakerModel] = []
    
    var body: some View {
        VStack {
            if currentInvoices.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No Bills Available")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Array(currentInvoices.enumerated()), id: \.offset) { index, invoice in
                            BillCard(invoice: invoice, index: index, onDelete: {
                                deleteBillAndRefresh(at: index)
                            })
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                HStack {
                    Text("Upload Another Bill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                        .onTapGesture {
                            imageDataModel.resetImageData()
                            visionModel.resetState()
                            router.goBackAndScanAgain()
                        }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.orange)
                .opacity(0.8)
                .cornerRadius(24)
                
                HStack {
                    Text("Sync with server")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.orange)
                .opacity(0.8)
                .cornerRadius(24)
            }
            .padding(.horizontal, 16)
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
                        Text("Back")
                    }
                }
            }
        }
        .onAppear {
            currentInvoices = invoiceMakerItems
        }
    }
    
    private func deleteBillAndRefresh(at index: Int) {
        StorageManager.shared.deleteInvoice(at: index)
        withAnimation {
            currentInvoices = StorageManager.shared.loadInvoices()
        }
    }
}

struct BillCard: View {
    var invoice: InvoiceMakerModel
    var index: Int
    var onDelete: () -> Void = {}
    
    @State private var date: String = ""
    @State private var personName: String = ""
    @State private var address: String = ""
    @State private var totalAmount: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Bill #\(index + 1)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
                Spacer()
                HStack(spacing: 12) {
                    Button(action: {
                        onDelete()
                    }) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding(.bottom, 4)
            
            Divider()
            
            VStack(spacing: 12) {
                HStack {
                    Text("Date")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(date)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                HStack {
                    Text("Person Name")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(personName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                HStack {
                    Text("Address")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(address)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Total Amount")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(totalAmount)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .onAppear {
            date = invoice.Date
            personName = invoice.personName
            address = invoice.address
            totalAmount = invoice.totalAmount
        }
    }
}

#Preview {
    CustomBillSummaryView(invoiceMakerItems: [
        InvoiceMakerModel(Date: "aaaa", totalAmount: "aaaa", address: "12 Crescent Close Fairiew 11027 United States", personName: "aaaa")
    ])
}


struct CustomTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
    }
}

extension Text {
    func customStyled() -> some View {
        self.modifier(CustomTextStyle())
    }
}
