//
//  MainView.swift
//  ConformingOverlayRegion
//
//  Created by Alex Albu on 29.01.2024.
//

import SwiftUI

@MainActor
struct MainView: View {
    
    // MARK: - Environment
    @Environment(\.modelContext) var modelContext
    
    // MARK: - States
    @StateObject private var mainViewModel = MainViewModel()
    @StateObject private var mapViewModel = MapViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.red
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                ActionButton(image: Image(systemName: "steeringwheel")) {
                    mainViewModel.isPresentingMapView = true
                }
                .padding()
                Text("Open Map")
                    .foregroundColor(.white)
                
                Spacer()
                
                ActionButton(image: Image(systemName: "checklist.checked")) {
                    mainViewModel.isPresentingScrollerView = true
                }
                .padding()
                Text("Open snapshots")
                    .foregroundColor(.white)

                Spacer()
            }
        }
        .sheet(isPresented: $mainViewModel.isPresentingScrollerView) {
            ScrollerView(images: mainViewModel.getImages(for: modelContext))
                .modelContext(modelContext)
        }
        .sheet(isPresented: $mainViewModel.isPresentingMapView) {
            MapView(viewModel: mapViewModel)
                .edgesIgnoringSafeArea(.bottom)
                .tint(.red)
                .onAppear {
                    mapViewModel.startLocationsServices()
                }
                .onDisappear {
                    Task {
                        await mapViewModel.onDisappear(context: modelContext)
                    }
                }
                .modelContext(modelContext)
        }
    }
}

// MARK: - Previews
#Preview {
    MainView()
}
