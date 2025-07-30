//
//  SuggestorChatMessageView.swift
//  sample
//
//  Created by ephrim.daniel on 25/07/25.
//

import SwiftUI

struct SuggestorChatMessageView: View {
    
    @State private var viewModel = SuggestorChatViewModel()
    @State private var showHistory: Bool = true
    @State private var showModal = false
    
    @State private var showBag = false
    
    @State var selectedOptions: [String] = [""]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    //if viewModel.messages.isEmpty {
                    SuggestorSuggestionView(viewModel: viewModel)
                    
                    //}
                    
                    //else {
                    SuggestorChatView(messages: viewModel.messages,
                             isLoading: viewModel.isResponding,
                             partial: viewModel.partial,
                             partialId: viewModel.partialId)
                    
                    //}
        
                    
                    
                    
                    Divider()
                    
                    
                }
                HStack {
                    TextField("Write a question here...", text: $viewModel.userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            Task {
                                await viewModel.sendMessage()
                            }
                            
                        }
                    Button("Send") {
                        Task {
                            await viewModel.sendMessage()
                        }
                    }
                    .disabled(viewModel.isResponding)
                }
                .padding()
                .navigationTitle("Vegetable Advisor")
                .toolbar {
                    Button("Restart") {
                        viewModel.reset()
                    }
                    
                    if showBag {
                        Button {
                            showModal = true
                        } label: {
                            Text("Add To Bag")
                                //.padding()
                                .fontWeight(.bold)
                                //.frame(maxWidth: .infinity)
                                .foregroundColor(.blue)
                                
                                
                                
                                .clipShape(.rect)
                                //.cornerRadius(10)
                                
                        }
                        
                        
                    }
                    
                }
                
            }
            .sheet(isPresented: $showModal) {
                Bag(selectedItems: selectedOptions)
            }
            .onPreferenceChange(BagPreferenceKey.self) { value in
                print(selectedOptions)
                showBag = true
                selectedOptions = Array(Set(value.filter { !$0.isEmpty }))
                showBag = selectedOptions.isEmpty ? false : true
            }
        }
        
    }
    
}


#Preview {
    SuggestorChatMessageView()
}

