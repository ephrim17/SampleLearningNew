import Foundation
internal import Combine

// MARK: - AirTagViewModel

class AirTagViewModel: ObservableObject {
    @Published var product: AirTagProduct
    @Published var selectedTier: PricingTier?
    @Published var quantity: Int = 1
    @Published var pricingTiers: [PricingTier] = []
    @Published var cartItems: [CartItem] = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var engravingText: String = ""
    @Published var showEngraving: Bool = false
    @Published var giftingText: String = ""
    
    init() {
        // Initialize product
        self.product = AirTagProduct(
            name: "AirTag",
            tagline: "Free Engraving",
            imageURL: "airtag",
            features: ["Precision finding technology", "Easy setup", "Works with iPhone, iPad, Mac, and Apple Watch"]
        )
        
        // Initialize pricing tiers
        self.pricingTiers = [
            PricingTier(quantity: 1, label: "1-pack", price: 3490, tax: ""),
            PricingTier(quantity: 4, label: "4-pack", price: 11900, tax: "")
        ]
        
        // Set default tier
        self.selectedTier = pricingTiers.first
    }
    
    // MARK: - Actions
    
    func selectTier(_ tier: PricingTier) {
        selectedTier = tier
        quantity = 1
    }
    
    func addToCart() {
        guard let tier = selectedTier else {
            alertMessage = "Please select a package"
            showAlert = true
            return
        }
        
        let item = CartItem(product: product, quantity: quantity, pricingTier: tier)
        cartItems.append(item)
        
        alertMessage = "✓ Added \(tier.label) to cart"
        showAlert = true
        
        // Reset
        quantity = 1
    }
    
    func removeFromCart(_ item: CartItem) {
        cartItems.removeAll { $0.id == item.id }
    }
    
    func cartTotal() -> Double {
        return cartItems.reduce(0) { $0 + $1.total }
    }
    
    func cartItemCount() -> Int {
        return cartItems.count
    }
}
