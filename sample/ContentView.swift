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
        
        let article = "Check the weather forecast and be prepared for changes, especially in desert climates. Always be aware of your surroundings, especially when hiking. Carry plenty of water and wear appropriate clothing.Follow Leave No Trace principles to protect the natural beauty of Joshua Tree."
        
        let session = LanguageModelSession()
        let response =  try await session.respond(to: "Does this article has the word Joshua: " + article)
           print(response)
       } catch {
           print(error)
       }
}
