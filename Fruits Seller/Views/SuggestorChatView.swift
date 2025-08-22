//
//  SuggestorChatView.swift
//  sample
//
//  Created by ephrim.daniel on 25/07/25.
//

import SwiftUI

struct SuggestorChatView: View {
    
    let messages: [ChatMessage]
    let isLoading: Bool
    
    let partial: SuggestedVegetable.PartiallyGenerated?
    let partialId: UUID?
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(messages) { message in
                    MarkdownText(markdown: message.content)
                        .modifier(StreamingViewModifier(sender: message.sender))
                }
                
                if let partial, let id = partialId, let vegetables = partial.vegetables{
                    SuggestorStreamingResponseView(partial: partial, itemsToPass: vegetables)
                        .id(id)
                } else if isLoading {
                    ProgressView()
                }
                    
            }
            .padding()
            .padding(.bottom, 100)
        }
    }
}

#Preview {
    ChatView(messages: ChatMessage.examples,
             isLoading: false,
             partial: nil,
             partialId: nil)
}

