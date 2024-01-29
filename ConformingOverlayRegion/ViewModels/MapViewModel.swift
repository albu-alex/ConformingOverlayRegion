//
//  MapViewModel.swift
//  ConformingOverlayRegion
//
//  Created by Alex Albu on 29.01.2024.
//

import SwiftUI
import SwiftData
import MapKit

class MapViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    private var userTrackingMode: MKUserTrackingMode = .follow
    private var mapView: MKMapView?
    
    private let options = MKMapSnapshotter.Options()
    private let DEFAULT_REGION_SPAN = 0.5
    
    var locationManager: CLLocationManager?
    var locations = [CLLocationCoordinate2D]()
    
    // MARK: - Methods
    
    func startLocationsServices() {
        locationManager = CLLocationManager()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        locationManager?.activityType = .automotiveNavigation
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func deallocateManagers() {
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }

    func drawLine() {
        mapView?.setUserTrackingMode(userTrackingMode, animated: true)
        let polyline = MKPolyline(coordinates: locations, count: locations.count)
        if let overlay = mapView?.overlays.first {
            mapView?.removeOverlay(overlay)
        }
        mapView?.addOverlay(polyline)
    }

    func injectMapView(_ mapView: MKMapView) {
        self.mapView = mapView
    }
    
    func createSnapshot() async -> String? {
        setupSnapshotter()
        let snapshotter = MKMapSnapshotter(options: options)

        do {
            let imageSnapshot = try await snapshotter.start()
            let pointsOnImage = locations.map { imageSnapshot.point(for: $0) }
            let image = UIImage.drawPointsOnImage(imageSnapshot.image, points: pointsOnImage)
            let imageData = image.jpegData(compressionQuality: 0.8)?.base64EncodedString()
            return imageData
        } catch {
            print("Something went wrong: \(error.localizedDescription)")
            return nil
        }
    }
    
    func onDisappear(context: ModelContext) async {
        deallocateManagers()
        let generatedSnapshotInBase64 = await createSnapshot() ?? ""
        let generatedUUID = UUID()
        
        createTrackingResultsObject(id: generatedUUID, base64Image: generatedSnapshotInBase64, for: context)
    }
    
    private func setupSnapshotter() {
        options.region = calculateRegionToFitOverlay(locations)
        options.mapType = .mutedStandard
        options.showsBuildings = true
        options.size = .init(width: 450, height: 800)
    }
    
    private func createTrackingResultsObject(id: UUID, base64Image: String, for modelContext: ModelContext) {
        let newTrackingResults = TrackingResults(id: UUID(), mapSnapshot: base64Image)
        modelContext.insert(newTrackingResults)
        
        try? modelContext.save()
    }
    
    private func calculateRegionToFitOverlay(_ coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        guard !coordinates.isEmpty else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 52.239647, longitude: 21.045845),
                span: MKCoordinateSpan(latitudeDelta: DEFAULT_REGION_SPAN, longitudeDelta: DEFAULT_REGION_SPAN)
            )
        }

        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }
        let minLat = latitudes.min()!
        let maxLat = latitudes.max()!
        let minLong = longitudes.min()!
        let maxLong = longitudes.max()!

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2.0,
            longitude: (minLong + maxLong) / 2.0
        )

        let span = MKCoordinateSpan(
            latitudeDelta: maxLat - minLat + 0.01,
            longitudeDelta: maxLong - minLong + 0.01
        )

        return MKCoordinateRegion(center: center, span: span)
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager else { return }
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            ToastService.shared.showToast(message: "Location is restricted", type: .info)
        case .denied:
            ToastService.shared.showToast(message: "Location is denied", type: .info)
        default:
            break
        }
    }
}

// MARK: - Extensions

extension MapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            checkLocationAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else { return }
        DispatchQueue.main.async { [self] in
            self.locations.append(coordinate)
            self.drawLine()
        }
    }
}
