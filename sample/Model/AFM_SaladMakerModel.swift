//
//  AFM_SaladMakerModel.swift
//  sample
//
//  Created by ephrim.daniel on 23/07/25.
//


import Foundation
import FoundationModels
import SwiftUI

@Generable()
struct SaladMaker: Equatable {
    
    @Guide(description: "Exciting Name for the salad")
    let name: String
    
    let ingredients: [Ingredient]
    
    @Guide(description: "Preparation steps")
    @Guide(.count(5))
    let instructions: [String]
    
    let preparationTime: String
    
    @Guide(description: "How difficulty to make the salad")
    let difficulty: DifficultyLevel
    
    let calories: Int
    
    @Guide(description: "Suggest a exciting seasoning to enhance the state")
    let suggestSeasoning: String
}

@Generable()
enum DifficultyLevel: String, Equatable{
    case easy
    case medium
    case hard
}

@Generable()
struct Ingredient: Equatable, Identifiable {
    var id = UUID()
    let name: String
    @Guide(description: "Quantity needed to prepare the salad ")
    let quantity: String
    @Guide(description: "Size of the fruit/vegetable should be")
    let unit: IngredientSize
}

@Generable()
enum IngredientSize: String, Equatable{
    case small
    case medium
    case large
}
