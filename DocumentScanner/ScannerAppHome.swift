import SwiftUI
internal import Combine

struct ScannerAppHome: View {
    @StateObject var router = Router()
    @StateObject var imageDataModel = ImageDataViewModel()
    @StateObject var visionModel = VisionModel()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            BackgroundContainerView {
                VStack(spacing: 0) {
                    // Top bar (avatar)
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 28))
                                .foregroundColor(.black)
                                .padding(8)
                        }
                    }
                    .safeAreaPadding(.all)
                    .padding(5)
                    // Greeting
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Hi Peter,")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.black)
                        Text("Welcome to the Bills Portal!")
                        // background image (add the image to Assets with name "ScannerBackground")
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    Spacer()
                    // Action buttons
                    VStack(spacing: 20) {
                        HStack(spacing: 0) {
                            Button(action: {
                                router.navigate(to: .scan)
                            }) {
                                Text("Upload Bill")
                                    .frame(maxWidth: .infinity)
                                    .font(.system(size: 20, weight: .semibold))
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 18)
                        HStack(spacing: 0) {
                            Button(action: {
                                let invoices = StorageManager.shared.loadInvoices()
                                if !invoices.isEmpty {
                                    router.navigate(to: .allSummaries(invoiceMakers: invoices))
                                } else {
                                    router.navigate(to: .emptyResults)
                                }
                            }) {
                                Text("View Results")
                                    .frame(maxWidth: .infinity)
                                    .font(.system(size: 20, weight: .semibold))
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 18)
                        Button(action: {
                            // Ask AI action placeholder
                        }) {
                            Text("Ask AI")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color.blue)
                        }
                        .padding(.top, 6)
                    }
                    // Help button bottom-right
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: 28))
                                .foregroundColor(.black.opacity(0.8))
                                .padding(8)
                        }
                    }
                    .safeAreaPadding(.all)
                    .padding(5)
                }
                // Navigation destinations
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .scan:
                        DocumentContentView()
                    case .allSummaries(let invoiceMakers):
                        CustomBillSummaryView(invoiceMakerItems: invoiceMakers)
                    case .emptyResults:
                        EmptyResultsView()
                    }
                }
            }
        }
        .environmentObject(router)
        .environmentObject(imageDataModel)
        .environmentObject(visionModel)
    }
}

#Preview {
    ScannerAppHome()
}


