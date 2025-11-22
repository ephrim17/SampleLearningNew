import SwiftUI

struct EmptyResultsView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            Image("scannerBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Spacer()
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
                Spacer()
                HStack(spacing: 0) {
                    Button(action: {
                    }) {
                        Text("Upload a Bill")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 82)
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
