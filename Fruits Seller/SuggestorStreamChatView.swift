//
//  SuggestorStreamChatView.swift
//  sample
//
//  Created by ephrim.daniel on 25/07/25.
//

import SwiftUI

struct SuggestorStreamingResponseView: View {
    
    let partial: SuggestedVegetable.PartiallyGenerated
    
    @State var itemsToPass : [String] = []
    
    var body: some View {
        
        VStack {
            
            if let vegetables = partial.vegetables{
                ForEach(vegetables, id: \.self) { veg in
                    Text(veg)
                        .modifier(StreamingViewModifier(sender: .assistant))
                        .contentTransition(.opacity)
                        .animation(.easeInOut(duration: 0.7), value: partial)
                        .showBagView(vegetables)
                }
                
            }
            
            MarkdownText(markdown: partial.benefits ?? "")
                .modifier(StreamingViewModifier(sender: .assistant))
                .contentTransition(.opacity)
                .animation(.easeInOut(duration: 0.7), value: partial)

        }
        
    }
}
