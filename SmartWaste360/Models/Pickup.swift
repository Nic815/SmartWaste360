//
//  Pickup.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import Foundation

struct Pickup: Identifiable {
    var id: String
    var userId: String
    var type: String          // Wet | Dry | E-Waste
    var address: String
    var description: String
    var status: String        // Scheduled → Assigned → In Progress → Completed
    var assignedWorker: String?
    var scheduledDate: Date?  // Assigned by admin
    var createdAt: Date
}


//import Foundation
//
//struct Pickup: Identifiable, Codable {
//    var id: String
//    var userId: String
//    var type: String
//    var address: String
//    var description: String
//    var status: String
//    var assignedWorkerId: String?
//    var assignedWorkerName: String?
//    var scheduledDate: Date?
//    var createdAt: Date?
//}
