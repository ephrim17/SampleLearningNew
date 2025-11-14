import SwiftUI

struct EmptyResultsView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 24) {
            
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                Text("No Bills Added")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Start scanning a bill to view results here")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            
            
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .navigationTitle("Results")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    router.reset()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EmptyResultsView()
            .environmentObject(Router())
    }
}
