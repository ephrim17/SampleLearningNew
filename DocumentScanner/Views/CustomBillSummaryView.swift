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
    var invoiceMakerItems: InvoiceMakerModel

    @EnvironmentObject var router: Router
    @EnvironmentObject var imageDataModel: ImageDataModel
    @EnvironmentObject var visionModel: VisionModel
    

    @State private var date: String = ""
    @State private var personName: String = ""
    @State private var address: String = ""
    @State private var totalAmount: String = ""

    var body: some View {
        VStack {
            
            Form {
                Section(header: Text("Bill Details").font(.headline)) {
                    LabeledContent {
                        TextField("Date", text: $date)
                            .multilineTextAlignment(.trailing)
                            .fontWeight(.semibold)// Aligns the input to the trailing edge
                    } label: {
                        Text("Date")
                            .customStyled()
                    }
                    
                    LabeledContent {
                        TextField("Person Name", text: $personName)
                            .multilineTextAlignment(.trailing)
                            .fontWeight(.semibold)// Aligns the input to the trailing edge
                    } label: {
                        Text("Person Name")
                            .customStyled()
                    }
                    
                    HStack {
                        Text("Address")
                            .customStyled()
                            .frame(width: 120, alignment: .leading) // Fixed width for label
                        
                        TextField("Address", text: $address)
                            .multilineTextAlignment(.trailing)
                            .fontWeight(.semibold)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.words)
                            .onChange(of: address) { _oldValue, newValue in
                                if newValue.contains("\n") {
                                    address = newValue.replacingOccurrences(of: "\n", with: " ")
                                }
                            }
                        // Optional: match LabeledContent style
                    }
                    
                    LabeledContent {
                        TextField("Total Amount", text: $totalAmount)
                            .multilineTextAlignment(.trailing)
                            .fontWeight(.semibold)// Aligns the input to the trailing edge
                    } label: {
                        Text("Total Amount")
                            .customStyled()
                    }
                    HStack(spacing: -5) {
                        Spacer()
                        BillAction(icon: "xmark.bin.circle.fill", foregroundColor: Color.red)
                            .frame(width: 50, height: 20)
                        BillAction(icon: "square.and.pencil.circle.fill", foregroundColor: Color.yellow)
                            .frame(width: 50, height: 20)
                        //                        Button("Save") {
                        //                            print("Button tapped!")
                        //                        }
                        //                        .tint(.green)
                        //                        .buttonStyle(.borderedProminent)
                    }
                }
                
            }
            
            Spacer()
            
            HStack{
                HStack{
                    Text("Upload Another Bill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                        .onTapGesture {
                            imageDataModel.resetImageData()
                            visionModel.resetState()
                            router.goBackAndScanAgain()
                        }
                }
                .frame(width: 150)
                .frame(height: 44)
                .background(Color.orange)
                .opacity(0.8)
                .cornerRadius(24)
                
                HStack{
                    Text("Sync with server")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                }
                .frame(width: 150)
                .frame(height: 44)
                .background(Color.orange)
                .opacity(0.8)
                .cornerRadius(24)
                
            }
        }
        
        .navigationTitle("Summary")
        .navigationBarBackButtonHidden(true)
        .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            router.reset()
                        }) {
                            // Recreate the standard back button appearance
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        }
                    }
                }
        .onAppear {
            // Initialize state from the provided model
            date = invoiceMakerItems.Date
            personName = invoiceMakerItems.personName
            address = invoiceMakerItems.address
            totalAmount = invoiceMakerItems.totalAmount
        }
    }
}

#Preview {
    CustomBillSummaryView(invoiceMakerItems: InvoiceMakerModel(Date: "aaaa", totalAmount: "aaaa", address: "12 Crescent Close Fairiew 11027 United Statses", personName: "aaaa"))
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
