import Foundation

struct PdpProduct: Identifiable, Codable {
    var id = UUID()
    let name: String
    let tagline: String
    let imageURL: String
    let features: [String]
    var tryOnAvailable: Bool
    var joystick3DAvailable: Bool
    var isEngravingAvailable: Bool
    
    init(name: String = "AirTag", tagline: String = "Free Engraving", imageURL: String = "airtag", features: [String] = [], tryOnAvailable: Bool = false, joystick3DAvailable: Bool = false, isEngravingAvailable: Bool = false) {
        self.name = name
        self.tagline = tagline
        self.imageURL = imageURL
        self.features = features
        self.tryOnAvailable = tryOnAvailable
        self.joystick3DAvailable = joystick3DAvailable
        self.isEngravingAvailable = isEngravingAvailable
    }
    
}

struct PricingTier: Identifiable, Hashable, Codable {
    var id = UUID()
    let quantity: Int
    let label: String
    let price: Double
    var currency: String = "$"
    let tax: String
    
    var priceDisplay: String {
        return "\(currency)\(Int(price)).00"
    }
    
    var taxDisplay: String {
        return "MRP \(currency)\(Int(price)).00 (Incl. of all taxes)\(tax)"
    }
}

struct CartItem: Identifiable, Codable {
    var id = UUID()
    var product: PdpProduct
    var quantity: Int
    var pricingTier: PricingTier
    
    var total: Double {
        return Double(quantity) * pricingTier.price
    }
}
