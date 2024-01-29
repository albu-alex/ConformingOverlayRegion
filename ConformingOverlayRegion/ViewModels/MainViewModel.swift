//
//  MainViewModel.swift
//  ConformingOverlayRegion
//
//  Created by Alex Albu on 29.01.2024.
//

import Foundation
import SwiftData
import SwiftUI

final class MainViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var isPresentingMapView = false
    @Published var isPresentingScrollerView = false
    
    func getImages(for modelContext: ModelContext) -> [UIImage] {
        let fetchDescriptor = FetchDescriptor<TrackingResults>()
        let trackingResults = try? modelContext.fetch(fetchDescriptor)
        
        let images = trackingResults?.map { trackingResult in
            let imageData = Data(base64Encoded: trackingResult.mapSnapshot)
            let image = UIImage(data: imageData ?? Data())
            return image!
        }
        
        return images ?? []
    }
}
