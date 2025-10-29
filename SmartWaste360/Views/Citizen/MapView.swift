//
//  MapView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI
import GoogleMaps

struct MapView: UIViewRepresentable {
    @Binding var bins: [Bin]
    @Binding var selectedType: String

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 28.6139, longitude: 77.2090, zoom: 12)
        return GMSMapView.map(withFrame: .zero, camera: camera)
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()
        for bin in bins where (selectedType == "All" || bin.type == selectedType) {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: bin.lat, longitude: bin.lng)
            marker.title = "\(bin.type) Bin"
            marker.map = mapView

            switch bin.type {
            case "Wet": marker.icon = GMSMarker.markerImage(with: .green)
            case "Dry": marker.icon = GMSMarker.markerImage(with: .blue)
            case "E-Waste": marker.icon = GMSMarker.markerImage(with: .red)
            default: break
            }
        }
    }
}
