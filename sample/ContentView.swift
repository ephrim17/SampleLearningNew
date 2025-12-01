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
        AFM_ASA_Entry()
        //FruitStarterPage()
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
        
        let article = "Dual 12MP cameras with a 12MP Ultra Wide camera and a 12MP Telephoto camera."
        
        let session = LanguageModelSession()
        let response =  try await session.respond(to: "Convert this article into a swiftui screen" + article)
           print(response)
       } catch {
           print(error)
       }
}
