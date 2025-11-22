//
//  BillCardView.swift
//  sample
//
//  Created by ephrim.daniel on 22/11/25.
//

import SwiftUI

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
    @State private var storeName: String = ""
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
                    Text("StoreName")
                        .font(.system(size: 13, weight: .semibold))
                    //.foregroundColor(.gray)
                    Spacer()
                    if isEditing {
                        // Use a TextEditor for multi-line address editing
                        TextEditor(text: $storeName)
                            .focused($focusedField, equals: .address)
                            .frame(minHeight: 60, maxHeight: 120)
                            .padding(6)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.25)))
                            .multilineTextAlignment(.trailing)
                    } else {
                        Text(storeName)
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                            .lineLimit(2)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Divider()
                
                HStack(alignment: .top) {
                    Text("Address")
                        .font(.system(size: 13, weight: .semibold))
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
                            .lineLimit(nil)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 180)
                    }
                }
                Divider()
                
                HStack {
                    Text("Total Amount")
                        .font(.system(size: 13, weight: .semibold))
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
        .onAppear {
            date = invoice.Date
            personName = invoice.personName
            address = invoice.address
            totalAmount = invoice.currencySymbol + " " + invoice.totalAmount
            currencySymbol = invoice.currencySymbol
            storeName = invoice.storeName
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
        let updated = InvoiceMakerModel(Date: date, totalAmount: totalAmount, currencySymbol: currencySymbol, storeName: storeName, address: address, personName: personName)
        onSave(updated)
        isEditing = false
        focusedField = nil
    }
}
