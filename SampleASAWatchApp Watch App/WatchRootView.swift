import SwiftUI

struct WatchRootView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("AirTag Detail") {
                    WatchAirTagDetailView()
                }
                NavigationLink("Sample Detail") {
                    SampleDetailView()
                }
            }
        }
        .navigationTitle("Products")
    }
}


#Preview("Watch Root") {
    WatchRootView()
}
