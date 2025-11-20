import SwiftUI

struct EmptyResultsView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            // subtle background
            Image("scannerBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack(spacing: 24) {
                
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                VStack(spacing: 8) {
                    Text("No Bills Yet")
                        .font(.title)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    Text("Upload a bill to get started")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            
                        }
                }
                
                
                
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
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
