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
        ZStack(alignment: .top) {
            // subtle background
            Image("scannerBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                if currentInvoices.isEmpty {
                    VStack(spacing: 16) {
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
                    }
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
                        }
                        .padding(.top, 100)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    HStack(spacing: 0) {
                        Button(action: {
                            //
                        }) {
                            Text("New Upload")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 20, weight: .semibold))
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    //.frame(width: 150)
                    
                    HStack(spacing: 0) {
                        Button(action: {
                            //
                        }) {
                            Text("Sync")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 20, weight: .semibold))
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    //.frame(width: 150)
                }
                .padding(.bottom, 60)
                .padding(.horizontal, 18)
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
    var onSave: (InvoiceMakerModel) -> Void = { _ in }
    
    @State private var date: String = ""
    @State private var personName: String = ""
    @State private var address: String = ""
    @State private var totalAmount: String = ""
    @State private var currencySymbol: String = ""
    @State private var isEditing: Bool = false
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable {
        case date, person, address, total
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            VStack(spacing: 12) {
                HStack {
                    Text("Date")
                        .font(.system(size: 13, weight: .semibold))
                        //.foregroundColor(.gray)
                    Spacer()
                    if isEditing {
                        TextField("Date", text: $date)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .date)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .person
                            }
                    } else {
                        Text(date)
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                    }
                }
                Divider()
                HStack {
                    Text("Person Name")
                        .font(.system(size: 13, weight: .semibold))
                        //.foregroundColor(.gray)
                    Spacer()
                    if isEditing {
                        TextField("Person Name", text: $personName)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .person)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .address
                            }
                    } else {
                        Text(personName)
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                    }
                }
                Divider()
                HStack(alignment: .top) {
                    Text("Address")
                        .font(.system(size: 13, weight: .semibold))
                        //.foregroundColor(.gray)
                    Spacer()
                    if isEditing {
                        // Use a TextEditor for multi-line address editing
                        TextEditor(text: $address)
                            .focused($focusedField, equals: .address)
                            .frame(minHeight: 60, maxHeight: 120)
                            .padding(6)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.25)))
                            .multilineTextAlignment(.trailing)
                    } else {
                        Text(address)
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                            .lineLimit(2)
                            .multilineTextAlignment(.trailing)
                    }
                }
                Divider()
                
                HStack {
                    Text("Total Amount")
                        .font(.system(size: 13, weight: .semibold))
                        //.foregroundColor(.gray)
                    Spacer()
                    if isEditing {
                        TextField("Total Amount", text: $totalAmount)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .total)
                            .submitLabel(.done)
                            .onSubmit {
                                saveEditing()
                            }
                    } else {
                        Text(totalAmount)
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                    }
                }
                
                Divider()
                HStack(spacing: 12) {
                    Spacer()
                    Button(action: {
                        onDelete()
                    }) {
                        Image(systemName: "xmark.bin")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                    }
                    
                    if isEditing {
                        Button(action: {
                            // Cancel edits
                            cancelEditing()
                        }) {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
                        
                        Button(action: {
                            saveEditing()
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
                    } else {
                        Button(action: {
                            startEditing()
                        }) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
                    }
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
            totalAmount = invoice.currencySymbol + invoice.totalAmount
            currencySymbol = invoice.currencySymbol
        }
        .toolbar {
            // Keyboard toolbar with Next / Done actions to move between fields
//            ToolbarItemGroup(placement: .keyboard) {
//                Spacer()
//                Button("Next") {
//                    switch focusedField {
//                    case .date:
//                        focusedField = .person
//                    case .person:
//                        focusedField = .address
//                    case .address:
//                        focusedField = .total
//                    default:
//                        focusedField = .total
//                    }
//                }
//                Button("Done") {
//                    saveEditing()
//                }
//            }
        }
    }
    
    private func startEditing() {
        isEditing = true
        // focus after a tiny delay to ensure TextField exists in view hierarchy
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            focusedField = .date
        }
    }
    
    private func cancelEditing() {
        // revert local state to original
        date = invoice.Date
        personName = invoice.personName
        address = invoice.address
        totalAmount = invoice.totalAmount
        isEditing = false
        focusedField = nil
    }
    
    private func saveEditing() {
        // Create updated model and call save callback
        let updated = InvoiceMakerModel(Date: date, totalAmount: totalAmount, currencySymbol: currencySymbol, address: address, personName: personName)
        onSave(updated)
        isEditing = false
        focusedField = nil
    }
}

#Preview {
    CustomBillSummaryView(invoiceMakerItems: [
        InvoiceMakerModel(Date: "aaaa", totalAmount: "aaaa", currencySymbol: "$", address: "12 Crescent Close Fairiew 11027 United States", personName: "aaaa")
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
