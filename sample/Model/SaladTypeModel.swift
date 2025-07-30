//
//  SaladTypeModel.swift
//  sample
//
//  Created by ephrim.daniel on 15/07/25.
//

import Foundation

////Added by ME
//struct SaladTypeModel: Codable {
//    var name: SaladType
//    var id: Int
//}
//
//enum SaladType: String, Codable {
//    case Fruits
//    case Veggies
//}

//From GHCP
struct SaladTypeModel: Identifiable, Codable {
    var id = UUID()
    let type: SaladType
}

enum SaladType: String, Codable, CaseIterable {
    case Fruits
    case Veggies
}
