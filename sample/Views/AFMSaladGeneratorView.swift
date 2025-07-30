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
                        
                        Text("Ingredients Required")
                            .fontWeight(.bold)
                            .font(.custom("Helvetica Neue", size: 18))
                        if let ingredients = salad.ingredients {
                            ForEach(ingredients, id: \.id) { item in
                                Text("\u{2022} \(item.name ?? "") \(item.quantity ?? "")")
                            }
                            Divider()
                        }
                        
                        
                        Text("Instructions to Prepare")
                            .fontWeight(.bold)
                            .font(.custom("Helvetica Neue", size: 18))
                        if let instructions = salad.instructions {
                            ForEach(instructions, id: \.self) { item in
                                Text("\u{2022} \(item)")
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
                                .font(.custom("Helvetica Neue", size: 18))
                            Text("\(calorieCount)")
                            Divider()
                        }
                        
                        
                        
                        if let seasoning = salad.suggestSeasoning {
                            Text("Season with")
                                .fontWeight(.bold)
                                .font(.custom("Helvetica Neue", size: 18))
                            Text(seasoning)
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
    AFMSaladGeneratorView()
}

struct DifficultyView: View{
    
    var level : DifficultyLevel
    
    var body: some View {
        HStack{
            Text("Difficulty Level")
                .fontWeight(.bold)
                .font(.custom("Helvetica Neue", size: 18))
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
                .font(.custom("Helvetica Neue", size: 18))
            if let preparationTime = salad.preparationTime {
                Text(preparationTime)
                    .fontWeight(.medium)
                    .font(.custom("Helvetica Neue", size: 14))
            }
        }
    }
}

