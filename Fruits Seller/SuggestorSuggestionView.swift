//
//  SuggestorSuggestionView.swift
//  sample
//
//  Created by ephrim.daniel on 25/07/25.
//

import SwiftUI

struct SuggestorSuggestionView: View {
    
    var viewModel: SuggestorChatViewModel
    
    let suggestions = [
        "Vegetable with high calories",
        "Vegetable with high protein",
        "Vegetable with high fiber",
        "Vegetable with low vitamins",
        "Vegetable good for heart health",
    ]
    
    var body: some View {
        
            VStack(spacing: 12) {
                Text("👨🏽‍⚕️")
                    .font(.system(size: 120))
                    .padding(.bottom, 12)
                
                ForEach(suggestions, id: \.self) { suggestion in
                    Button {
                        viewModel.userInput = suggestion
                        Task{
                            await viewModel.sendMessage()
                        }
                    } label: {
                        Text(suggestion)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
            }
        }
    
}


