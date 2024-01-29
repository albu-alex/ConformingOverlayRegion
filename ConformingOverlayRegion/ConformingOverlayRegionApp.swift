//
//  ConformingOverlayRegionApp.swift
//  ConformingOverlayRegion
//
//  Created by Alex Albu on 29.01.2024.
//

import SwiftUI
import SwiftData

@main
struct ConformingOverlayRegionApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: TrackingResults.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(modelContainer)
        }
    }
}
