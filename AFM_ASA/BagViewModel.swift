//
//  BagViewModel.swift
//  sample
//
//  Created by ephrim.daniel on 01/12/25.
//

import Foundation
internal import Combine

class BagViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    var cartTotal: Double {
        cartItems.map { (item) -> Double in
            // TODO: Align with actual CartItem property names. Assuming `unitPrice` exists; fallback to 0 if not.
            let unitPrice: Double
            if let value = (item as AnyObject).value(forKey: "price") as? Double {
                unitPrice = value
            } else if let value = (item as AnyObject).value(forKey: "unitPrice") as? Double {
                unitPrice = value
            } else {
                unitPrice = 0
            }
            return unitPrice * Double(item.quantity)
        }.reduce(0, +)
    }
    
    var cartSavings: Double {
        cartItems.map { (item) -> Double in
            // TODO: Align with actual CartItem property names. Assuming `savings` or `discount` exists; fallback to 0 if not.
            let perUnitSavings: Double
            if let value = (item as AnyObject).value(forKey: "savings") as? Double {
                perUnitSavings = value
            } else if let value = (item as AnyObject).value(forKey: "discount") as? Double {
                perUnitSavings = value
            } else {
                perUnitSavings = 0
            }
            return perUnitSavings * Double(item.quantity)
        }.reduce(0, +)
    }
    
    var formattedTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₹"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: cartTotal)) ?? "₹0.00"
    }
    
    var formattedSavings: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₹"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: cartSavings)) ?? "₹0.00"
    }
    
    func updateQuantity(_ item: CartItem, quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            if quantity > 0 {
                cartItems[index].quantity = quantity
            } else {
                cartItems.remove(at: index)
            }
        }
    }
    
    func removeItem(_ item: CartItem) {
        cartItems.removeAll { $0.id == item.id }
    }
    
    func checkout() {
        alertMessage = "Proceeding to checkout with \(cartItems.count) item(s)"
        showAlert = true
    }
    
    func initiateCheckout() {
        checkout()
    }
}

