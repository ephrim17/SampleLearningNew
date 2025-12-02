//
//  GiftingMessageSuggestor.swift
//  sample
//
//  Created by ephrim.daniel on 03/12/25.
//

import SwiftUI

struct GiftingMessageSuggestor: View {
    
    @Binding var suggestedString: String
    
    let suggestions = [
        "Anniversary Greeting",
        "Birthday Greetings",
        "New Year wishes",
        "Special day",
    ]
    
    var body: some View {
            VStack(spacing: 12) {
                Text("Tell us something like below")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .cornerRadius(10)
                    .foregroundStyle(Color(.secondaryLabel))
                
                ForEach(suggestions, id: \.self) { suggestion in
                    Button {
                        suggestedString = suggestion
                    } label: {
                        Text(suggestion)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.1))
                            .foregroundStyle(Color(.secondaryLabel))
                            .cornerRadius(10)
                    }
                }
            }
        }
    
}


