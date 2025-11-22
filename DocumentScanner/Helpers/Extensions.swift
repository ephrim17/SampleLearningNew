//
//  Extensions.swift
//  sample
//
//  Created by ephrim.daniel on 22/11/25.
//

import SwiftUI

extension Text {
    func customStyled() -> some View {
        self.modifier(CustomTextStyle())
    }
}
