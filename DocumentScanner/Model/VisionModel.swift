/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Provides a class to detect and parse a table containing contact information.
*/

import SwiftUI
import Vision
internal import DataDetection
import FoundationModels
internal import Combine


class VisionModel: ObservableObject {
    
    enum AppError: Error {
        case noDocument
        case noTable
        case invalidPoint
    }
    
    /// The first table detected in the document.
    @Published var table: DocumentObservation.Container.Table? = nil
    
    @Published var paragraph: DocumentObservation.Container.Text? = nil
    
    @Published var newParagraphs : [DocumentObservation.Container.Text] = []
    /// A list of contacts extracted from the table.
    var contacts = [Contact]()
    
    //Summarized by AFM
    @Published var summarisedData: InvoiceMakerModel? = nil
    @Published var showBillSummary: Bool = false
    
    //ShowLoading
    @Published var isShowLoading: Bool = true
    @Published var loadingText: String = ""
    
    private var currentTask: Task<Void, Never>?
    
    deinit {
        currentTask?.cancel()
    }
    
    /// Run Vision document recognition on the image to parse a table.
    func recognizeTable(in image: Data) async {
        resetState()
        
        // Cancel any previous task
        currentTask?.cancel()
        
        currentTask = Task {
            do {
                self.loadingText = "Recognizing document..."
                let table = try await extractTable(from: image)
                
                // Check if task was cancelled
                if !Task.isCancelled {
                    self.table = table
                    self.contacts = parseTable(table)
                }
            } catch {
                if !Task.isCancelled {
                    print(error)
                }
            }
        }
    }
    
    /// Clear data from previous table detection.
    func resetState() {
        // Cancel any running task
        currentTask?.cancel()
        currentTask = nil
        
        self.table = nil
        self.contacts = []
        self.summarisedData = nil
        self.paragraph = nil
        self.newParagraphs = []
        self.showBillSummary = false
        self.loadingText = ""
    }
    
    /// Convert a simple table into a TSV string format compatible with pasting into Notes & Numbers.
    ///
    /// Simple tables have at most 1 line per cell, and no cells that span multiple rows or columns.
    func exportTable() async throws -> String {
        guard let rows = self.table?.rows else {
            throw AppError.noTable
        }
        // Map each row into a tab-delimited line.
        let tableRowData = rows.map { row in
            return row.map({ $0.content.text.transcript }).joined(separator: "\t")
        }
        // Create a multiline string with one row per line.
        
        var textParagraph = ""
        
        for (index, item) in self.newParagraphs.enumerated() {
            print(item.transcript)
            textParagraph.append(item.transcript)
        }
        
        //print("<<<<<< BEFORE AFM")
        //print(textParagraph)
        isShowLoading = false
        do {
            loadingText = "Analyzing document..."
            summarisedData = try await summarizeArticle(articleText: textParagraph)
            withAnimation {
                showBillSummary = true
            }
            showBillSummary = true
            
        } catch {
            print("Summarization failed:", error)
        }
        
        return tableRowData.joined(separator: "\n")
    }
    
    func summarizeArticle(articleText: String) async throws -> InvoiceMakerModel {
        // 1. Create a LanguageModelSession
        let session = LanguageModelSession()
        
        let prompt = "Take a summary of the following article and give date, currency symbol, total amount, address and person name , :\n\n" + articleText
        
        do {
            let afmResponse = try await session.respond(generating: InvoiceMakerModel.self) {
                prompt
            }
            loadingText = ""
            return afmResponse.content
        } catch {
            print("LanguageModelSession respond failed:", error)
            throw error
        }

        // 2. Formulate the prompt
      

        // 3. Send the prompt and await the response
        //let response = try await session.respond(to: prompt)

        // 4. Return the summarized content
        //return afmResponse.content
    }

    /// Process an image and return the first table detected.
    private func extractTable(from image: Data) async throws -> DocumentObservation.Container.Table {
        
        // The Vision request.
        let request = RecognizeDocumentsRequest()
        
        // Perform the request on the image data and return the results.
        let observations = try await request.perform(on: image)

        // Get the first observation from the array.
        guard let document = observations.first?.document else {
            throw AppError.noDocument
        }
        
        //extract lines
//        guard let para = document.paragraphs else {
//            throw AppError.noTable
//        }
        
        for (index, item) in document.paragraphs.enumerated() {
            print(item.transcript)
            print("<<<<<<")
            
            if item.transcript == "Total:" {
                print("<<< TOTAL BILL \(document.paragraphs[index + 1].transcript)")
            }
        }
        newParagraphs = document.paragraphs
        //paragraph = para
        
        // Extract the first table detected.
        guard let table = document.tables.first else {
            throw AppError.noTable
        }
        
        return table
    }
    
    /// Extract name, email addresses, and phone number from a table into a list of contacts.
    private func parseTable(_ table: DocumentObservation.Container.Table) -> [Contact] {
        var contacts = [Contact]()
        
        //iterate para
        
//        for text in paragraph?.lines {
//            print("text \(text.transcript)")
//        }
        
        // Iterate over each row in the table.
        for row in table.rows {
            // The contact name will be taken from the first column.
            guard let firstCell = row.first else {
                continue
            }
            // Extract the text content from the transcript.
            let name = firstCell.content.text.transcript
            
            // Look for emails and phone numbers in the remaining cells.
            var detectedPhone: String? = nil
            var detectedEmail: String? = nil
            
            for cell in row.dropFirst() {
                // Get all detected data in the cell, then match emails and phone numbers.
                for data in cell.content.text.detectedData {
                    switch data.match.details {
                    case .emailAddress(let email):
                        detectedEmail = email.emailAddress
                    case .phoneNumber(let phoneNumber):
                        detectedPhone = phoneNumber.phoneNumber
                    default:
                        break
                    }
                }
            }
            
            // Create a contact if an email was detected.
            if let email = detectedEmail {
                let contact = Contact(name: name, email: email, phoneNumber: detectedPhone)
                contacts.append(contact)
            }
        }
    
        return contacts
    }
}

extension DocumentObservation.Container.Table {
    /// Returns the contents of cell that a user clicked on.
    func cell(at point: NormalizedPoint) -> TableCell? {
        let visionPoint = point.cgPoint
        // Verify the point falls inside the bounding region of the table.
        guard self.boundingRegion.normalizedPath.contains(visionPoint) else {
            return nil
        }
        // Inspect each cell.
        for row in self.rows {
            for cell in row {
                // Check if the point falls inside the cell.
                if cell.content.boundingRegion.normalizedPath.contains(visionPoint) {
                    return TableCell(cell)
                }
            }
        }
        return nil
    }
}


@Generable()
struct InvoiceMakerModel: Equatable, Hashable, Codable {
    
    @Guide(description: "Date from the given text")
    let Date: String
    
    @Guide(description: "totalAmount from the given text should be in numbers as string")
    let totalAmount: String
    
    @Guide(description: "currency symbol")
    let currencySymbol: String
    
    @Guide(description: "address from the given text")
    let address: String
    
    @Guide(description: "personName from the given text")
    let personName: String

}
