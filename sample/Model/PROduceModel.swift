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
    
    enum Codingkeys: String, CodingKey {
        case name = "name"
        case image = "image"
        case id = "id"
    }
}
