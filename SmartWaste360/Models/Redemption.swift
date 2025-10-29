//
//  Redemption.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import Foundation

struct Redemption: Identifiable, Codable {
    var id: String
    var userId: String
    var requestedPoints: Int
    var status: String        // Pending → Approved → Rejected
}
