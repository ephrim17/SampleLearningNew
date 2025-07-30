//
//  SaladTypeViewMdoel.swift
//  sample
//
//  Created by ephrim.daniel on 15/07/25.
//

import SwiftUI
import Foundation
internal import Combine

class SaladTypeViewMdoel: ObservableObject {
    
    @Published var items : [SaladTypeModel]?
    
    func loadItems() {
        self.items = [ SaladTypeModel(id: UUID(), type: .Fruits),
                       SaladTypeModel(id: UUID(), type: .Veggies)
        ]
    }
}


