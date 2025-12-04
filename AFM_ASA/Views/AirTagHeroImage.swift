//
//  AirTagHeroImage.swift
//  sample
//
//  Created by ephrim.daniel on 04/12/25.
//

import SwiftUI

// MARK: - Reusable AirTag Hero Image

struct AirTagHeroImage: View {
    var height: CGFloat = 300
    var verticalPadding: CGFloat = 20

    var body: some View {
        Image("airtag")
            .resizable()
            .scaledToFit()
            .frame(height: height)
            .padding(.vertical, verticalPadding)
    }
}
