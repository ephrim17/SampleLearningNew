import SwiftUI

// MARK: - AirTag Detail View (Main Content)

struct AirTagDetailView: View {
    @StateObject var viewModel = AirTagViewModel()
    @State private var showBag = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header with back button, title, and actions
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Color.gray.opacity(0.3))
                                    .clipShape(Circle())
                            }
                            Spacer()
                            HStack(spacing: 12) {
                                Button(action: {}) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                        .background(Color.gray.opacity(0.3))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                
                                Button(action: {}) {
                                    Image(systemName: "bookmark")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                        .background(Color.gray.opacity(0.3))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        
                        // Product Title
                        VStack(spacing: 8) {
                            Text(viewModel.product.name)
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .frame(alignment: .center)
                            
                            Text(viewModel.product.tagline)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.orange)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .frame(alignment: .center)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        
                        // Product Image
                        HeroImage(height: 300, verticalPadding: 20)
                        
                        // Gallery Button
                        Button(action: {}) {
                            Text("Gallery")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(height: 44)
                                .frame(maxWidth: 120)
                                .background(Color.gray.opacity(0.4))
                                .clipShape(Capsule())
                        }
                        .padding(.vertical, 20)
                        
                        // Quantity Question
                        VStack(alignment: .leading, spacing: 16) {
                            Text("How many would you like?")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Pricing Tiers
                            VStack(spacing: 12) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.pricingTiers, id: \.id) { tier in
                                        PricingCardView(
                                            tier: tier,
                                            isSelected: viewModel.selectedTier?.id == tier.id,
                                            action: {
                                                viewModel.selectTier(tier)
                                            }
                                        )
                                    }
                                }
                                
                                if viewModel.selectedTier == nil {
                                    Text("From \(viewModel.pricingTiers.first?.priceDisplay ?? "0.00")")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .background(Color.gray.opacity(0.3))
                                        .padding(.horizontal, -20)
                                }
                            }
                            
                            // Engraving Section (Shown after selecting a pricing tier)
                            if viewModel.selectedTier != nil {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Engraving")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.white)

                                    Text("Engrave a mix of emoji, initials and numbers to make AirTag unmistakably yours. Only at Apple.")
                                        .font(.system(size: 15))
                                        .foregroundColor(Color.white.opacity(0.6))
                                        .fixedSize(horizontal: false, vertical: true)

                                    Image("airtag")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 220)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.vertical, 8)

                                    Button(action: {
                                        viewModel.showEngraving = true
                                    }) {
                                        Text("Add Engraving")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 52)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 26)
                                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                            )
                                    }
                                    .background(Color.clear)
                                    .clipShape(Capsule())
                                }
                                .padding(.top, 24)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        
                        // Add to Cart / Gift Message
                        VStack(spacing: 16) {
                            
                            if viewModel.selectedTier != nil {
                                
                                if let price = viewModel.selectedTier?.priceDisplay {
                                    Text("Buy For \(price)")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .background(Color.gray.opacity(0.3))
                                        .padding(.horizontal, -20)
                                }
                                
                                Button(action: {
                                    viewModel.addToCart()
                                }) {
                                    HStack(spacing: 8) {
                                        Text("Add to Bag")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color.blue)
                                    .clipShape(Capsule())
                                }
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "gift")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                Text("Add a free digital gift message")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            HStack(spacing: 8) {
                                Image(systemName: "face.smiling")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                Text("Free Personal Engraving")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                    }
                    .onAppear { if viewModel.selectedTier != nil { viewModel.selectedTier = nil }
                    }
                }
            }
            .background(Color(.systemGray6).opacity(0.1))
            .sheet(isPresented: $viewModel.showEngraving) {
                AirTagEngravingView(isPresented: $viewModel.showEngraving, engraving: $viewModel.engravingText)
            }
            .navigationDestination(isPresented: $showBag) {
                BagView(viewModel: viewModel)
            }
            .alert("Product added to bag", isPresented: $viewModel.showAlert) {
                Button("OK") {
                    showBag = true
                }
            } message: {
                //Text(viewModel.alertMessage)
            }
        }
    }
}

// MARK: - Pricing Card View

struct PricingCardView: View {
    let tier: PricingTier
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .center, spacing: 12) {
                Text(tier.label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(tier.taxDisplay)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(isSelected ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
    }
}

// MARK: - Preview

#Preview {
    AirTagDetailView()
}

