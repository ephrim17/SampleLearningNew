//
//  PROduceModel.swift
//  sample
//
//  Created by ephrim.daniel on 15/07/25.
//

struct PROduceModel: Codable, Hashable{
    let name: String
    let image: String
    let id : Int
    let color : String
    let rating : String
    let description : String
    let offer : String
    let price : String
    
    enum Codingkeys: String, CodingKey {
        
        case name = "name"
        case image = "image"
        case id = "id"
        case color = "color"
        
        case rating = "rating"
        case description = "description"
        case offer = "offer"
        case price = "price"
        
    }
}
