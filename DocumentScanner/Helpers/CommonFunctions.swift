//
//  CommonFunctions.swift
//  sample
//
//  Created by ephrim.daniel on 22/11/25.
//

import SwiftUI

// Helper to get the top safe area inset without using deprecated APIs
 func topSafeAreaInset() -> CGFloat {
    // Find the key window from the connected scenes and return its top safe area inset
    let scenes = UIApplication.shared.connectedScenes
    for scene in scenes {
        guard let windowScene = scene as? UIWindowScene else { continue }
        // Use UIWindowScene.windows (not deprecated) and find the key window
        if let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            return keyWindow.safeAreaInsets.top
        }
    }
    return 0
}

func bottomSafeAreaInset() -> CGFloat {
   // Find the key window from the connected scenes and return its top safe area inset
   let scenes = UIApplication.shared.connectedScenes
   for scene in scenes {
       guard let windowScene = scene as? UIWindowScene else { continue }
       // Use UIWindowScene.windows (not deprecated) and find the key window
       if let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
           return keyWindow.safeAreaInsets.bottom
       }
   }
   return 0
}
