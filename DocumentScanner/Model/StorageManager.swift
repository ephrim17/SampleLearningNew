import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let invoicesKey = "saved_invoices_array"
    private let userDefaults = UserDefaults.standard
    
    /// Save InvoiceMakerModel to UserDefaults (adds to array)
    func saveInvoice(_ invoice: InvoiceMakerModel) {
        do {
            var invoices = loadInvoices()
            invoices.insert(invoice, at: 0) // Add to the beginning
            let encoded = try JSONEncoder().encode(invoices)
            userDefaults.set(encoded, forKey: invoicesKey)
        } catch {
            print("Error saving invoice: \(error)")
        }
    }
    
    /// Load all InvoiceMakerModels from UserDefaults
    func loadInvoices() -> [InvoiceMakerModel] {
        guard let data = userDefaults.data(forKey: invoicesKey) else {
            return []
        }
        
        do {
            let decoded = try JSONDecoder().decode([InvoiceMakerModel].self, from: data)
            return decoded
        } catch {
            print("Error loading invoices: \(error)")
            return []
        }
    }
    
    /// Delete a specific invoice at index
    func deleteInvoice(at index: Int) {
        var invoices = loadInvoices()
        if index >= 0 && index < invoices.count {
            invoices.remove(at: index)
            do {
                let encoded = try JSONEncoder().encode(invoices)
                userDefaults.set(encoded, forKey: invoicesKey)
            } catch {
                print("Error deleting invoice: \(error)")
            }
        }
    }
    
    /// Delete all invoices
    func deleteAllInvoices() {
        userDefaults.removeObject(forKey: invoicesKey)
    }
    
    /// Check if any invoices exist
    func hasInvoices() -> Bool {
        return !loadInvoices().isEmpty
    }

    /// Update an invoice at a specific index and persist the array
    func updateInvoice(at index: Int, with invoice: InvoiceMakerModel) {
        var invoices = loadInvoices()
        guard index >= 0 && index < invoices.count else { return }
        invoices[index] = invoice
        do {
            let encoded = try JSONEncoder().encode(invoices)
            userDefaults.set(encoded, forKey: invoicesKey)
        } catch {
            print("Error updating invoice: \(error)")
        }
    }
}
