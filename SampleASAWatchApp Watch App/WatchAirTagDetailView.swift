//
//  WatchAirTagDetailView.swift
//  sample
//
//  Created by ephrim.daniel on 04/12/25.
//

import SwiftUI

struct WatchAirTagDetailView: View {
    @StateObject var viewModel = AirTagViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                // Title
                Text(viewModel.product.name)
                    .font(.system(size: 18, weight: .bold))
                    .multilineTextAlignment(.center)

                Text(viewModel.product.tagline)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.orange)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 4)

                // Reused hero image
                AirTagHeroImage(height: 120, verticalPadding: 8)

                // Pricing tiers (vertical for watch)
                VStack(spacing: 6) {
                    ForEach(viewModel.pricingTiers, id: \.id) { tier in
                        WatchPricingCardView(
                            tier: tier,
                            isSelected: viewModel.selectedTier?.id == tier.id,
                            action: { viewModel.selectTier(tier) }
                        )
                    }
                }

                if let price = viewModel.selectedTier?.priceDisplay {
                    Text("Buy for \(price)")
                        .font(.system(size: 12, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(6)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }

                Button("Add to Bag") {
                    viewModel.addToCart()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
            .padding(10)
        }
        .background(Color.black)
        .alert("Product added to bag", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

struct WatchPricingCardView: View {
    let tier: PricingTier
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .center, spacing: 4) {
                Text(tier.label)
                    .font(.system(size: 12, weight: .semibold))
                Text(tier.priceDisplay)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(6)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
    }
}

#Preview("Watch Detail") {
    WatchAirTagDetailView()
}
