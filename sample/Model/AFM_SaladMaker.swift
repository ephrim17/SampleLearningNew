//
//  AFM_SaladMaker.swift
//  sample
//
//  Created by ephrim.daniel on 15/07/25.
//

import Foundation
import FoundationModels
import SwiftUI

@Observable
final class SaladAFMPlannerViewModel {
    
    private(set) var saladMaker: SaladMaker.PartiallyGenerated?
    private var session : LanguageModelSession
    
    var PROduce = [String]()
    
    init(PROduce: [String]){
        self.PROduce = PROduce
        self.session = LanguageModelSession(
            instructions: Instructions{
                "Your Job is to create a salad for the user"
                """
                Here is a description of \(PROduce) for your reference \
                when considering what salad to generate:
                """
                "here is an example:"
                "But don't copy it"
                SaladMaker.appleSalad
            }
        )
        
        let supportedLanguages = SystemLanguageModel.default.supportedLanguages
        //print("<<< supportedLanguages")
        //print(supportedLanguages)
    }
    
    func suggestSalad(PROduce: String) async throws {
        let streamResponse = session.streamResponse(generating: SaladMaker.self) {
            "Create a Salad from the given \(PROduce)."
            "Give it a delicious title."
        }
        
        for try await partialResponse in streamResponse {
            self.saladMaker =  partialResponse
        }
    }
    
    func prewarm(){
        session.prewarm()
    }
}


extension SaladMaker {
    static let appleSalad = SaladMaker(name: "Delicious Apple Salad", ingredients: [Ingredient(id: UUID(), name: "Apple", quantity: "250 grams", unit: .medium)], instructions: ["Cut Apple into pieces", "Take curd and seasoning for your choice"], preparationTime: "3 minutes", difficulty: .easy, calories: 300, suggestSeasoning: "Add chia seeds and lime")
}


