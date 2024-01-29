//
//  ActionButton.swift
//  ConformingOverlayRegion
//
//  Created by Alex Albu on 29.01.2024.
//

import SwiftUI

struct ActionButton: View {
    private let image: Image
    private let imageSize: Double
    private let action: () -> Void
    
    init(image: Image, imageSize: Double = 50, action: @escaping () -> Void) {
        self.image = image
        self.imageSize = imageSize
        self.action = action
    }
    
    // MARK: - Lifecycle

    var body: some View {
        Button(action: action) {
            image
                .resizable()
                .frame(width: imageSize, height: imageSize)
        }
        .foregroundColor(.white)
        .padding()
    }
}

#Preview {
    ActionButton(image: Image(systemName: "scribble")) { }
}
