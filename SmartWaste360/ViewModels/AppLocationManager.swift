//
//  LocationManager.swift
//  SmartWaste360
//
//  Created by NIKHIL on 16/10/25.
//

//import Foundation
//import CoreLocation
//import Combine
//
//class AppLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let manager = CLLocationManager()
//    private let geocoder = CLGeocoder()
//    
//    @Published var city: String = "Fetching..."
//    @Published var permissionDenied = false
//
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        requestPermission()
//    }
//    
//    func requestPermission() {
//        if CLLocationManager.locationServicesEnabled() {
//            manager.requestWhenInUseAuthorization()
//            manager.startUpdatingLocation()
//        } else {
//            permissionDenied = true
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedWhenInUse, .authorizedAlways:
//            manager.startUpdatingLocation()
//        case .denied, .restricted:
//            permissionDenied = true
//            city = "Location Off"
//        default:
//            break
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//
//        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
//            if let place = placemarks?.first {
//                DispatchQueue.main.async {
//                    self.city = place.locality ?? "Unknown"
//                }
//            }
//        }
//        manager.stopUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("❌ Location error:", error.localizedDescription)
//        city = "Error"
//    }
//}


import Foundation
import CoreLocation
import Combine

class AppLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var city: String = "Fetching..."
    @Published var fullAddress: String = ""
    @Published var permissionDenied = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        requestPermission()
    }
    
    func requestPermission() {
        if CLLocationManager.locationServicesEnabled() {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        } else {
            permissionDenied = true
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            permissionDenied = true
            city = "Location Off"
        default: break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            if let place = placemarks?.first {
                DispatchQueue.main.async {
                    self.city = place.locality ?? "Unknown"
                    self.fullAddress = [
                        place.name,
                        place.locality,
                        place.administrativeArea
                    ]
                    .compactMap { $0 }
                    .joined(separator: ", ")
                }
            }
        }
        manager.stopUpdatingLocation()
    }
}
