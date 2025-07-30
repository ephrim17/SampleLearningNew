//
//  ChatMessageView.swift
//  sample
//
//  Created by ephrim.daniel on 23/07/25.
//

import SwiftUI

struct ChatMessageView: View {
    
    @State private var viewModel = ChatViewModel()
    @State private var showHistory: Bool = true
    @State private var showModal = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    //if viewModel.messages.isEmpty {
                    SuggestionsView(viewModel: viewModel)
                    
                    //}
                    
                    //else {
                    ChatView(messages: viewModel.messages,
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
                    Button {
                        showModal = true
                    } label: {
                        Label("", systemImage: "bag.fill")
                    }
                }
                
            }
            .sheet(isPresented: $showModal) {
                Bag(selectedItems: ["Cabbage", "garlic", "Leafy Greens"])
            }
        }
        
    }
    
}


#Preview {
    ChatMessageView()
}

struct MarkdownText: View {
    let markdown: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(parseLines(from: markdown), id: \.self) { line in
                render(line: line)
            }
        }
    }
    
    @ViewBuilder
    func render(line: String) -> some View {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        
        if trimmed.hasPrefix("- ") {
            HStack(alignment: .top, spacing: 8) {
                Text("•")
                Text(try! AttributedString(markdown: String(trimmed.dropFirst(2))))
            }
        } else {
            Text(try! AttributedString(markdown: trimmed))
        }
    }
    
    func parseLines(from markdown: String) -> [String] {
        markdown.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    }
}

#Preview {
    MarkdownText(markdown: """
        Hello world
        *this is* bold and **italic**
        text
        
        **Description**: Poodles are highly intelligent.
        - **Grooming**: Needs brushing
        - **Exercise**: Daily
        """)
}

