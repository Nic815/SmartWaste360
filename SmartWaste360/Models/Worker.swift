//
//  Worker.swift
//  SmartWaste360
//
//  Created by NIKHIL on 15/10/25.
//

import Foundation

struct Worker: Identifiable, Codable {
    var id: String
    var name: String
    var email: String?
    var phone: String?
    var address: String?
    var status: String? // "Available" / "Busy"
    var createdAt: Date?
}

