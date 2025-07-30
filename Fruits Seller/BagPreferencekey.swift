//
//  BagPreferencekey.swift
//  sample
//
//  Created by ephrim.daniel on 25/07/25.
//

import SwiftUI
import Foundation

struct BagPreferenceKey: PreferenceKey {
    static var defaultValue: [String] = []
    
    static func reduce(value: inout [String], nextValue: () -> [String]) {
        value.append(contentsOf: nextValue())
    }
}
    
extension View {
    func showBagView(_ items: [String]) -> some View {
        preference(key: BagPreferenceKey.self, value: items) // This is just a placeholder value
    }
}
