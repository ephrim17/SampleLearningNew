//
//  SampleASAWatchAppApp.swift
//  SampleASAWatchApp Watch App
//
//  Created by ephrim.daniel on 04/12/25.
//

import SwiftUI

@main
struct SampleASAWatchApp_Watch_AppApp: App {
    @State private var openDetail = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WatchRootView()
                    .navigationDestination(isPresented: $openDetail) {
                        SampleDetailView()
                    }
            }
            .onOpenURL { url in
                // Expect URLs like: myapp://sampledetail or widget-deeplink://sampledetail
                if url.host == "sampledetail" || url.pathComponents.contains("sampledetail") {
                    openDetail = true
                }
            }
        }
    }
}
