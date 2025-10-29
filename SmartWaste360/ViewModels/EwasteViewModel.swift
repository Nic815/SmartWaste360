//
//  EwasteViewModel.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

extension UIImage {
    /// Resize the image so its longest side is maxSize
    func resized(toMax maxSize: CGFloat) -> UIImage {
        let aspectRatio = size.width / size.height
        var newSize: CGSize
        if aspectRatio > 1 {
            newSize = CGSize(width: maxSize, height: maxSize / aspectRatio)
        } else {
            newSize = CGSize(width: maxSize * aspectRatio, height: maxSize)
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.7)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resized ?? self
    }
}

class EwasteViewModel: ObservableObject {
    @Published var ewastes: [Ewaste] = []
    private let db = Firestore.firestore()

    // MARK: - Citizen: Register Ewaste
    func registerEwaste(itemName: String,
                        isWorking: Bool,
                        address: String,
                        image: UIImage?,
                        completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }

        var base64String = ""
        if let img = image {
            // ✅ Resize to max 800px width/height
            let resized = img.resized(toMax: 800)

            // ✅ Compress heavily (quality = 0.4)
            if let data = resized.jpegData(compressionQuality: 0.4) {
                base64String = data.base64EncodedString()
            }
        }

        let newEwaste: [String: Any] = [
            "userId": user.uid,
            "itemName": itemName,
            "isWorking": isWorking,
            "address": address,
            "imageBase64": base64String,
            "status": "Registered",
            "assignedWorker": NSNull(),
            "scheduledDate": NSNull(),
            "workerCompleted": false,
            "rewardGiven": false,
            "createdAt": Timestamp(date: Date())
        ]

        db.collection("ewaste").addDocument(data: newEwaste) { err in
            if let err = err {
                print("❌ Error saving ewaste: \(err.localizedDescription)")
                completion(false)
            } else {
                print("✅ Ewaste registered successfully (compressed image)")
                completion(true)
            }
        }
    }

    // MARK: - Admin: Assign Worker & Date
//    func assignWorkerAndDate(ewasteId: String, workerName: String, date: Date) {
//        db.collection("ewaste").document(ewasteId).updateData([
//            "assignedWorker": workerName,
//            "scheduledDate": Timestamp(date: date),
//            "status": "Assigned"
//        ]) { err in
//            if let err = err {
//                print("❌ Error assigning worker: \(err.localizedDescription)")
//            } else {
//                print("✅ Worker \(workerName) assigned for ewaste \(ewasteId)")
//            }
//        }
//    }
    
    // MARK: - Admin: Assign Worker & Date (Full Sync)
    func assignWorkerAndDate(ewasteId: String, workerName: String, workerId: String, date: Date) {
        let timestamp = Timestamp(date: date)
        let db = Firestore.firestore()

        // 1️⃣ Update E-Waste entry
        db.collection("ewaste").document(ewasteId).updateData([
            "assignedWorker": workerName,
            "assignedWorkerId": workerId,
            "status": "Assigned",
            "scheduledDate": timestamp
        ]) { err in
            if let err = err {
                print("❌ Error assigning worker: \(err.localizedDescription)")
            } else {
                print("✅ Worker \(workerName) assigned for ewaste \(ewasteId)")
            }
        }

        // 2️⃣ Update Worker Collection
        db.collection("workers").document(workerId).updateData([
            "status": "Busy",
            "assignedPickupId": ewasteId
        ]) { err in
            if let err = err {
                print("❌ Failed to update worker: \(err.localizedDescription)")
            } else {
                print("✅ Worker status updated to Busy")
            }
        }

        // 3️⃣ Mirror the update in the Users Collection
        db.collection("users").document(workerId).updateData([
            "status": "Busy",
            "assignedPickupId": ewasteId
        ]) { err in
            if let err = err {
                print("❌ Failed to mirror to users: \(err.localizedDescription)")
            } else {
                print("✅ Synced worker status to users collection")
            }
        }
    }

    
    
    func fetchEwaste(forWorkerOnly: Bool = false, completion: @escaping (Bool) -> Void = { _ in }) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }

        var query: Query = db.collection("ewaste").order(by: "createdAt", descending: true)

        if forWorkerOnly {
            // ✅ Filter by assignedWorkerId (not name)
            query = query.whereField("assignedWorkerId", isEqualTo: user.uid)
        }

        query.addSnapshotListener { snapshot, error in
            guard let docs = snapshot?.documents else {
                completion(false)
                return
            }

            self.ewastes = docs.map { doc in
                let data = doc.data()
                return Ewaste(
                    id: doc.documentID,
                    userId: data["userId"] as? String ?? "",
                    itemName: data["itemName"] as? String ?? "",
                    isWorking: data["isWorking"] as? Bool ?? true,
                    address: data["address"] as? String ?? "",
                    imageBase64: data["imageBase64"] as? String ?? "",
                    status: data["status"] as? String ?? "Registered",
                    assignedWorker: data["assignedWorker"] as? String ?? "",
                    scheduledDate: (data["scheduledDate"] as? Timestamp)?.dateValue(),
                    workerCompleted: data["workerCompleted"] as? Bool ?? false,
                    createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                )
            }
            completion(true)
        }
    }

    // MARK: - Fetch Ewaste
    func fetchEwaste(forUserOnly: Bool = false) {
        var query: Query = db.collection("ewaste").order(by: "createdAt", descending: true)

        if forUserOnly, let user = Auth.auth().currentUser {
            query = query.whereField("userId", isEqualTo: user.uid)
        }

        query.addSnapshotListener { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            self.ewastes = docs.map { doc in
                let data = doc.data()
                return Ewaste(
                    id: doc.documentID,
                    userId: data["userId"] as? String ?? "",
                    itemName: data["itemName"] as? String ?? "",
                    isWorking: data["isWorking"] as? Bool ?? false,
                    address: data["address"] as? String ?? "",
                    imageBase64: data["imageBase64"] as? String ?? "",
                    status: data["status"] as? String ?? "Registered",
                    assignedWorker: data["assignedWorker"] as? String,
                    scheduledDate: (data["scheduledDate"] as? Timestamp)?.dateValue(),
                    workerCompleted: data["workerCompleted"] as? Bool ?? false, // ✅ load flag
                    createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                )
            }

        }
    }
}
