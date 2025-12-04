//
//  BagView.swift
//  sample
//
//  Created by ephrim.daniel on 01/12/25.
//

import SwiftUI

struct BagView: View {
    @ObservedObject var viewModel: AirTagViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showGifting = false
    
    init(viewModel: AirTagViewModel) {
        self.viewModel = viewModel
    }

    private var exploreOffersButton: some View {
        Button(action: {}) {
            Text("Explore Current Offers")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.blue)
                .frame(height: 48)
                .padding(.leading, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.15))
                .clipShape(Capsule())
        }
        .contentShape(Rectangle())
        .padding(20)
        
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {
                    
                        exploreOffersButton
                        // Cart Items
                        Group {
                            if viewModel.cartItems.isEmpty {
                                emptyBagView
                            } else {
                                cartItemsList
                            }
                        }
                        questionsSection
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("Check Out")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(8)
                        .background(Color.blue)
                        .clipShape(Capsule())
                        .onTapGesture {
                            showGifting = true
                        }
                    
                
                    //.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityLabel("Check Out")
                }
            }
            .navigationTitle("Bag")
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showGifting) {
                GiftingView { result in
                    viewModel.giftingText = result
                }
            }
        }
    }
    
    private var emptyBagView: some View {
        VStack(spacing: 16) {
            Image(systemName: "bag")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text("Your bag is empty")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    private var cartItemsList: some View {
        VStack(spacing: 0) {
            // Grouped container with unified background
            VStack(spacing: 0) {
                // Cart Items
                ForEach(viewModel.cartItems, id: \.id) { item in
                    BagItemCardRow(item: item)
                }

                // Offers & Info placed directly after items with no spacing
                Group {
                    if !viewModel.cartItems.isEmpty {
                        offersAndInfoSection
                            .background(Color.clear)
                    }
                }
            }
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var offersAndInfoSection: some View {
        VStack(spacing: 12) {
            if !viewModel.cartItems.isEmpty {
                savingsInfo
            }
            giftingMessage
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    private var savingsInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            let totalSavings: Double = 220.00
            Text("Get up to \(String(format: "₹%.2f", totalSavings)) savings with eligible card(s)*")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.orange)
            Text("Pay 15.99% pa for 6 months:*")
                .font(.system(size: 14))
                .foregroundColor(.white)
            Text("₹8467.00/mo.")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            Text("◊◊")
                .font(.system(size: 10))
                .foregroundColor(.white)
            Text("Order today. Gift Delivers:\n9 Dec – 11 Dec - Free")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.7))
            Text("Save for later")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var giftingMessage: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !viewModel.giftingText.isEmpty {
                Text("Your Gifting Message: ")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.orange)
                //Show personal message her
                Text(viewModel.giftingText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
    }

    private var questionsSection: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Still have questions?")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Text("Connect with a Specialist for answers.")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "phone.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
        }
        .padding(16)
        .background(Color.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Bag Item Card
struct BagItemCardRow: View {
    let item: CartItem

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                Image("airtag")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(item.product.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        Spacer()

                        Text(item.pricingTier.priceDisplay)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }

                    HStack(spacing: 4) {
                        Text("Quantity \(item.quantity)")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.7))

                        Text("|")
                            .foregroundColor(.white.opacity(0.5))

                        Text("Item Price: ₹\(item.pricingTier.priceDisplay)")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            .padding(16)

            // Divider between rows
            Divider().background(Color.white.opacity(0.08))
        }
    }
}

#Preview {
    BagView(viewModel: AirTagViewModel())
}

