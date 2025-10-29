//
//  Bin.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import Foundation

struct Bin: Identifiable, Codable {
    var id: String
    var type: String          // Wet | Dry | E-Waste
    var lat: Double
    var lng: Double
}
