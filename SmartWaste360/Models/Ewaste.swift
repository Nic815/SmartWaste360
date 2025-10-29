//
//  Ewaste.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import Foundation
import UIKit

struct Ewaste: Identifiable {
    var id: String
    var userId: String
    var itemName: String
    var isWorking: Bool
    var address: String
    var imageBase64: String
    var status: String        // Registered → Assigned → Completed
    var assignedWorker: String?
    var scheduledDate: Date?
    var workerCompleted: Bool
    var createdAt: Date

    // Computed property for Base64 → UIImage
    var uiImage: UIImage? {
        if let data = Data(base64Encoded: imageBase64) {
            return UIImage(data: data)
        }
        return nil
    }
}
