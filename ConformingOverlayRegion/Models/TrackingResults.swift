//
//  TrackingResults.swift
//  ConformingOverlayRegion
//
//  Created by Alex Albu on 29.01.2024.
//

import SwiftData
import Foundation

@Model
class TrackingResults {
    @Attribute(.unique) var id: UUID
    var mapSnapshot: String
    
    init(id: UUID, mapSnapshot: String) {
        self.id = id
        self.mapSnapshot = mapSnapshot
    }
}
