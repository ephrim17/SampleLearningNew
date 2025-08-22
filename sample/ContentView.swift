//
//  ContentView.swift
//  sample
//
//  Created by ephrim.daniel on 14/07/25.
//

import SwiftUI
import Playgrounds
import FoundationModels

struct ContentView: View {
    var body: some View {
        FruitStarterPage()
    }
}

#Playground {
//    let session = SaladAFMPlanner(PROduce: "Apple")
//    do  {
//        var response = try await session.suggestSaladPlay(PROduce: "Apple Orange")
//        print(response)
//    } catch {
//        print(error)
//    }
    do  {
        
        let instructions = "you are a mobile store sales person"
        let session = LanguageModelSession(instructions: instructions)
        let response =  try await session.respond(to: "hi")
           print(response)
       } catch {
           print(error)
       }
}
