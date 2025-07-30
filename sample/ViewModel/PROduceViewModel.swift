//
//  PROduceViewModel.swift
//  sample
//
//  Created by ephrim.daniel on 15/07/25.
//

import Foundation
import SwiftUI
internal import Combine

class PROduceViewModel: ObservableObject {
    
    @Published var items : [PROduceModel]?
    
    func loadItems(type: SaladType) {
        switch type  {
        case .Fruits:
            let fruitModel = JsonProvider.shared.getData(type: PROduceModel.self, file: "fruits")
            items = fruitModel
            break
        case .Veggies:
            let vegModel = JsonProvider.shared.getData(type: PROduceModel.self, file: "veggies")
            items = vegModel
            break
        }
    }
}
