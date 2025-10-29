//
//  BinLocatorView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI

struct BinLocatorView: View {
    var body: some View {
        VStack {
            // Automatically open Google Maps when this view appears
            Text("Opening Google Maps...")
                .onAppear {
                    openGoogleMaps()
                }
        }
    }

    private func openGoogleMaps() {
        let query = "Public toilets"
        let mapsAppUrl = "comgooglemaps://?q=\(query)"
        let mapsWebUrl = "https://www.google.com/maps/search/?api=1&query=\(query)"

        if let url = URL(string: mapsAppUrl), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: mapsWebUrl) {
            UIApplication.shared.open(url)
        }
    }
}
