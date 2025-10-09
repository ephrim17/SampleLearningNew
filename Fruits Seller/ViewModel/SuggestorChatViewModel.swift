//
//  SuggestorChatViewModel.swift
//  sample
//
//  Created by ephrim.daniel on 25/07/25.
//

import Foundation

import SwiftUI
import FoundationModels


@Observable
class SuggestorChatViewModel {
    
    var messages: [ChatMessage] = []
    var userInput: String = ""
    var isResponding = false
    
    
    var partial: SuggestedVegetable.PartiallyGenerated?
    var partialId: UUID?
    
    private(set) var session: LanguageModelSession
    
    private let instructions = """
   You are a health specialist. Your job is to give helpful suggestions and advice people to Buy Vegetables for heart patients.
   """
    
    private var streamingTask: Task<Void, Never>?
    
    init() {
        self.session = LanguageModelSession(
            instructions: instructions
        )
    }

    func sendMessage() async {
        
        guard !isResponding else { return }
        guard !userInput.isEmpty else { return }
        isResponding = true
        
        messages.append(ChatMessage(sender: .user, content: userInput))
        let userInput = self.userInput
        self.userInput = ""
        
//      streamingTask = Task {
            do {
                let streamResponse = session.streamResponse(generating: SuggestedVegetable.self) {
                    userInput
                }
                self.partialId = UUID()
                
                
                
                for try await partial in streamResponse {
                    //print(partial)
                    //self.partial = partial
                }
                
                guard !Task.isCancelled else { return }
                
                messages.append(ChatMessage(sender: .assistant,
                                            content: partial?.benefits ?? "",
                                            id: partialId ?? UUID()))
                
               
                
                self.isResponding = false
                self.partial = nil
                self.partialId = nil
                //self.streamingTask = nil
                
            } catch {
                print("error: \(error)")
                if let error = error as? FoundationModels.LanguageModelSession.GenerationError {
                    print("error: \(error.localizedDescription)")
                }
                
                messages.append(ChatMessage(sender: .assistant,
                                            content: error.localizedDescription,
                                            id: partialId ?? UUID()))
                
                isResponding = false
                //streamingTask = nil
                
            }
       //}
    }
    
    func reset() {
        messages = []
        userInput = ""
        isResponding = false
        
        //streamingTask?.cancel()
        //streamingTask = nil
        
        session = LanguageModelSession(
            instructions: instructions
        )
    }
}
