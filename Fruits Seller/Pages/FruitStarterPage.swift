//
//  FruitStarterPage.swift
//  sample
//
//  Created by ephrim.daniel on 20/08/25.
//

import SwiftUI

struct FruitStarterPage: View {
    @AppStorage("isOnBoarded") var isOnBoarded: Bool = false
    
    var body: some View {
        NavigationStack {
            if isOnBoarded {
                // Show the main content view if logged in
                HomePage()
            } else {
                // Show the login/onboarding view if not logged in
                OnBoardingPage()
            }
        }
    }
}

