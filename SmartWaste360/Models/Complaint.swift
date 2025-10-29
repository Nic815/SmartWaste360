//
//  Complaint.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import Foundation
import UIKit

struct Complaint: Identifiable {
    var id: String
    var userId: String
    var description: String
    var imageBase64: String
    var status: String
    var escalationLevel: Int
    var createdAt: Date
    
    let assignedWorker: String?
    let assignedWorkerId: String?
    let assignedDate: Date?
    let workerCompleted: Bool


    // Convert Base64 → UIImage
    var uiImage: UIImage? {
        if let data = Data(base64Encoded: imageBase64) {
            return UIImage(data: data)
        }
        return nil
    }
}
