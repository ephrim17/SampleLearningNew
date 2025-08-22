//
//  AFMSaladGeneratorView.swift
//  sample
//
//  Created by ephrim.daniel on 15/07/25.
//

import SwiftUI

struct AFMSaladGeneratorView: View {
    
    @State private var viewModel: SaladAFMPlannerViewModel?
    
    var selectedFruits = [String]()
    
    var body: some View {
        ScrollView{
            if let saladReady = viewModel {
                VStack {
                    if let salad = saladReady.saladMaker{
                        SaladHeader(salad: salad)
                            .showAddToCartButton(true)
                        Text("Ingredients Required")
                            .fontWeight(.bold)
                            .modifier(TextViewModifierForFruitSeller())
                        if let ingredients = salad.ingredients {
                            ForEach(ingredients, id: \.id) { item in
                                Text("\u{2022} \(item.name ?? "") \(item.quantity ?? "")")
                                    .modifier(TextViewModifierForFruitSeller())
                            }
                            Divider()
                        }
                        
                        
                        Text("Instructions to Prepare")
                            .fontWeight(.bold)
                            .modifier(TextViewModifierForFruitSeller())
                        if let instructions = salad.instructions {
                            ForEach(instructions, id: \.self) { item in
                                Text("\u{2022} \(item)")
                                    .modifier(TextViewModifierForFruitSeller())
                            }
                            Divider()
                        }
                        
                       
                        
                        if let difficulty = salad.difficulty {
                            DifficultyView(level: difficulty )
                            Divider()
                        }
                       
                        
                        if let calorieCount = salad.calories {
                            Text("Total Calorie Count")
                                .fontWeight(.bold)
                                .modifier(TextViewModifierForFruitSeller())
                            Text("\(calorieCount)")
                                .modifier(TextViewModifierForFruitSeller())
                            Divider()
                        }
                        
                        
                        
                        if let seasoning = salad.suggestSeasoning {
                            Text("Season with")
                                .fontWeight(.bold)
                                .modifier(TextViewModifierForFruitSeller())
                            Text(seasoning)
                                .modifier(TextViewModifierForFruitSeller())
                            Divider()
                        }
                        PreparationTime(salad: salad)
                        Divider()
                    }
                }.padding()
            }
        }.task {
            viewModel = SaladAFMPlannerViewModel(PROduce: selectedFruits)
            viewModel?.prewarm()
            do {
                try await viewModel?.suggestSalad(PROduce: selectedFruits[0])
            } catch{
                print(error)
            }
        }
    }
}

#Preview {
    //AFMSaladGeneratorView()
}

struct DifficultyView: View{
    
    var level : DifficultyLevel
    
    var body: some View {
        HStack{
            Text("Difficulty Level")
                .fontWeight(.bold)
                .modifier(TextViewModifierForFruitSeller())
            Circle()
                .fill(getDiffColor())
                .frame(width: 15, height: 15)
        }
        
    }
    
    func getDiffColor () -> Color {
        switch level {
        case .easy:
            return .green
        case .medium:
            return .yellow
        case .hard:
            return .red
        }
    }
}


struct SaladHeader: View {
    
    var salad : SaladMaker.PartiallyGenerated
    
    var body: some View {
        if let title = salad.name {
            Text(title)
                .fontWeight(.bold)
                .font(.custom("Helvetica Neue", size: 30))
        }
        Divider()
    }
}


struct PreparationTime: View {
    
    var salad : SaladMaker.PartiallyGenerated
    
    var body: some View {
        HStack{
            Text("Prepration Time: ")
                .fontWeight(.bold)
                .modifier(TextViewModifierForFruitSeller())
            if let preparationTime = salad.preparationTime {
                Text(preparationTime)
                    .fontWeight(.medium)
                    .modifier(TextViewModifierForFruitSeller())
            }
        }
    }
}

