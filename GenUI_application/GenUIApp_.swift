//
//  GenUIApp_.swift
//  sample
//
//  Created by ephrim.daniel on 01/12/25.
//

import SwiftUI
import FoundationModels

struct GenUIApp_: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                Task {
                    do {
                        let summary = try await summarizeRequest()
                        print("Summary :", summary)
                    } catch {
                        print("summarizeRequest failed:", error)
                    }
                }
            }
    }
}

#Preview {
    GenUIApp_()
}


func summarizeRequest(articleText: String = "") async throws -> String {
    // 1. Create a LanguageModelSession
    let session = LanguageModelSession()
    
    let prompt = "Suggest only apple products"
    
    do {
//        let afmResponse = try await session.respond(generating: InvoiceMakerModel.self) {
//            prompt
            
        let afmResponse = try await session.respond(to: "I need a new laptop for college that can handle video editing and last all day" + prompt)
        
        return afmResponse.content
    } catch {
        print("LanguageModelSession respond failed:", error)
        throw error
    }

    // 2. Formulate the prompt
  

    // 3. Send the prompt and await the response
    //let response = try await session.respond(to: prompt)

    // 4. Return the summarized content
    //return afmResponse.content
}

