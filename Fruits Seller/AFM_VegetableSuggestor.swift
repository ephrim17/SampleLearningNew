//
//  AFM_VegetableSuggestor.swift
//  sample
//
//  Created by ephrim.daniel on 25/07/25.
//

import Foundation
import FoundationModels
import SwiftUI

@Generable()
struct SuggestedVegetable: Equatable {
    
    @Guide(description: "Suggest vegetable names")
    let vegetables: [String]
    
    @Guide(description: "Suggest calories")
    let calories: Int
    
    @Guide(description: "benefits of the vegetable")
    let benefits: String
}



