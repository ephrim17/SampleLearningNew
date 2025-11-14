import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let invoiceKey = "saved_invoice_maker_model"
    private let userDefaults = UserDefaults.standard
    
    /// Save InvoiceMakerModel to UserDefaults
    func saveInvoice(_ invoice: InvoiceMakerModel) {
        do {
            let encoded = try JSONEncoder().encode(invoice)
            userDefaults.set(encoded, forKey: invoiceKey)
        } catch {
            print("Error saving invoice: \(error)")
        }
    }
    
    /// Load InvoiceMakerModel from UserDefaults
    func loadInvoice() -> InvoiceMakerModel? {
        guard let data = userDefaults.data(forKey: invoiceKey) else {
            return nil
        }
        
        do {
            let decoded = try JSONDecoder().decode(InvoiceMakerModel.self, from: data)
            return decoded
        } catch {
            print("Error loading invoice: \(error)")
            return nil
        }
    }
    
    /// Delete saved invoice from UserDefaults
    func deleteInvoice() {
        userDefaults.removeObject(forKey: invoiceKey)
    }
    
    /// Check if invoice exists
    func hasInvoice() -> Bool {
        return userDefaults.data(forKey: invoiceKey) != nil
    }
}
