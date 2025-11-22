import SwiftUI
import Vision

struct ImageView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var imageDataModel: ImageDataViewModel
    @EnvironmentObject var viewModel: VisionModel
    @State var imageData: Data?
    
    @State private var loadingMessage = ""
    @State private var isPopoverPresented = false
    @State private var isAlertShowing = false
    @State private var selectedCell: TableCell? = nil
    
    var body: some View {
        ZStack {
             VStack{
                 if let uiImage = UIImage(data: imageDataModel.imageData ?? Data()) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 300, height: 400)
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .overlay {
                            if let table = viewModel.table {
                                GeometryReader { geometry in
                                    ZStack {
                                        // Draw bounding boxes around the table and its cells.
                                        BoundingBox(region: table.boundingRegion)
                                            .stroke(.blue, lineWidth: 1.0)
                                            .contentShape(Rectangle())
                                        ForEach(table.rows, id: \.hashValue) { row in
                                            ForEach(row, id: \.hashValue) { cell in
                                                BoundingBox(region: cell.content.boundingRegion)
                                                    .stroke(.blue, style: .init(lineWidth: 1.0, dash: [5]))
                                            }
                                        }
                                    }
                                    .onTapGesture { point in
                                        selectCell(containing: point, in: geometry.size)
                                    }
                                }
                            }
                            if !viewModel.newParagraphs.isEmpty {
                                ZStack {
                                    ForEach(viewModel.newParagraphs, id: \.hashValue) { para in
                                        BoundingBox(region: para.boundingRegion)
                                            .stroke(.blue, lineWidth: 1.0)
                                            .contentShape(Rectangle())
                                        ForEach(para.lines, id: \.hashValue) { line in
                                            BoundingBox(region: line.boundingRegion)
                                                .stroke(.blue, style: .init(lineWidth: 1.0, dash: [5]))
                                        }
                                    }
                                }.onAppear {
                                    copyTable()
                                }
                                
                            }
                            if let para = viewModel.paragraph {
                                GeometryReader { geometry in
                                    ZStack {
                                        // Draw bounding boxes around the table and its cells.
                                        BoundingBox(region: para.boundingRegion)
                                            .stroke(.blue, lineWidth: 4.0)
                                            .contentShape(Rectangle())
                                        ForEach(para.lines, id: \.hashValue) { line in
                                            BoundingBox(region: line.boundingRegion)
                                                .stroke(.blue, style: .init(lineWidth: 2.0, dash: [5]))
                                        }
                                    }
                                }
                            }
                        }
                        .popover(isPresented: $isPopoverPresented,
                                 attachmentAnchor: .point(selectedCell?.location ?? .bottom)
                        ) {
                            if let cell = selectedCell {
                                makePopoverView(cell)
                                    .padding(20)
                                    .presentationCompactAdaptation(.popover)
                            }
                        }
                }
                if viewModel.showBillSummary {
                    HStack(spacing: 0) {
                        Button(action: {
                            if let invoiceMakerItems = viewModel.summarisedData {
                                StorageManager.shared.saveInvoice(invoiceMakerItems)
                                let allInvoices = StorageManager.shared.loadInvoices()
                                router.navigate(to: .allSummaries(invoiceMakers: allInvoices))
                            }
                            imageDataModel.imageData = nil
                            viewModel.resetState()
                        }) {
                            Text("Save Updated Bill")
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
                            //imageDataModel.imageData = nil
                            //viewModel.resetState()
                        }) {
                            Text("Re-Upload Bill")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 20, weight: .semibold))
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 18)
                }
            }
            LoadingOverlayView(loadingText: viewModel.loadingText)
        }
        .task {
            // Process the image with Vision's document recognition.
            await viewModel.recognizeTable(in: imageDataModel.imageData ?? Data())
        }
        .onDisappear {
            viewModel.resetState()
        }
    }
    
    /// Copy the detected table to the clipboard and show an alert upon success.
    private func copyTable() {
        Task {
            UIPasteboard.general.string = try await viewModel.exportTable()
            withAnimation {
                isAlertShowing = true
            }
            try? await Task.sleep(for: .seconds(5))
            withAnimation {
                isAlertShowing = false
            }
        }
    }
    
    /// Select the table cell that the user tapped on.
    private func selectCell(containing point: CGPoint, in viewBounds: CGSize) {
        // Convert the screen point to normalized coordinates.
        let point = NormalizedPoint(imagePoint: point, in: viewBounds)
        // Convert to Vision's coordinate system.
        let visionPoint = point.verticallyFlipped()
        // Find the table cell that contains this point.
        selectedCell = viewModel.table?.cell(at: visionPoint)
        if selectedCell != nil {
            isPopoverPresented = true
        }
    }
}
