//
//  DS_Router.swift
//  sample
//
//  Created by ephrim.daniel on 14/11/25.
//

import SwiftUI
internal import Combine

enum Route: Hashable {
    case scan
    case summary(invoiceMaker: InvoiceMakerModel)
    case emptyResults
}

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    @EnvironmentObject var visionViewModel: VisionModel
    @EnvironmentObject var imageDataViewModel: ImageDataModel
    
    func reset() {
        path = NavigationPath()
    }
    
    func removeLast() {
        path.removeLast()
    }
    
    func navigate(to destination: Route) {
        path.append(destination)
    }
    
    func goBackAndScanAgain() {
        path.removeLast()
    }
    
}
