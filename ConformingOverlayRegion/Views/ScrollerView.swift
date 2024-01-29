//
//  ScrollerView.swift
//  ConformingOverlayRegion
//
//  Created by Alex Albu on 29.01.2024.
//

import SwiftUI

struct ScrollerView: View {
    // MARK: - Properties
    let images: [UIImage]
    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    
    // MARK: - State
    // Step 3: Manage Selected Image Index
    @State private var selectedImageIndex: Int = 0

    var body: some View {
        ZStack {
            // Step 4: Background Color
            Color.secondary
                .ignoresSafeArea()

            // Step 5: Create TabView for Carousel
            TabView(selection: $selectedImageIndex) {
                // Step 6: Iterate Through Images
                ForEach(0..<images.count, id: \.self) { index in
                    ZStack(alignment: .topLeading) {
                        // Step 7: Display Image
                        Image(uiImage: images[index])
                            .resizable()
                            .tag(index)
                            .frame(width: 365.625, height: 650)
                    }
                    .background(VisualEffectBlur()) // Step 8: Apply Visual Effect Blur
                    .shadow(radius: 20) // Step 9: Apply Shadow
                }
            }
            .frame(height: 650) // Step 10: Set Carousel Height
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Step 11: Customize TabView Style
            .ignoresSafeArea()

            // Step 12: Navigation Dots
            HStack {
                ForEach(0..<images.count, id: \.self) { index in
                    // Step 13: Create Navigation Dots
                    Capsule()
                        .fill(Color.white.opacity(selectedImageIndex == index ? 1 : 0.33))
                        .frame(width: 35, height: 8)
                        .onTapGesture {
                            // Step 14: Handle Navigation Dot Taps
                            selectedImageIndex = index
                        }
                }
                .offset(y: 350) // Step 15: Adjust Dots Position
            }
        }
        .onReceive(timer) { _ in
            // Step 16: Auto-Scrolling Logic
            withAnimation(.default) {
                selectedImageIndex = (selectedImageIndex + 1) % images.count
            }
        }
    }
}
