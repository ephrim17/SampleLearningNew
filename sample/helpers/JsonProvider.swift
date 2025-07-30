//
//  JsonProvider.swift
//  sample
//
//  Created by ephrim.daniel on 15/07/25.
//

import Foundation

class JsonProvider {
        
    static let shared = JsonProvider()
    
    func getData <G: Codable> (type: G.Type, file: String) -> [G] {
        let genericData = [G]()
        do {
            if let bundlePath = Bundle.main.path(forResource: file, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return try JSONDecoder().decode([G].self, from: jsonData)
            }
            
        } catch {
            print(error)
        }
        return genericData
    }
}
