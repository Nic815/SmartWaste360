//
//  PickupViewModel.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class PickupViewModel: ObservableObject {
    @Published var pickups: [Pickup] = []
    private let db = Firestore.firestore()

    // MARK: - Citizen: Book Pickup
    func bookPickup(type: String,
                    address: String,
                    description: String,
                    completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }

        let newPickup: [String: Any] = [
            "userId": user.uid,
            "type": type,
            "address": address,
            "description": description,
            "status": "Scheduled",
            "assignedWorker": NSNull(),
            "scheduledDate": NSNull(),
            "rewardGiven": false, 
            "createdAt": Timestamp(date: Date())
        ]

        db.collection("pickups").addDocument(data: newPickup) { err in
            if let err = err {
                print("❌ Error saving pickup: \(err.localizedDescription)")
                completion(false)
            } else {
                print("✅ Pickup saved successfully")
                completion(true)
            }
        }
    }

    // MARK: - Admin: Assign Worker & Date
//    func assignWorkerAndDate(pickupId: String, workerName: String, date: Date) {
//        db.collection("pickups").document(pickupId).updateData([
//            "assignedWorker": workerName,
//            "scheduledDate": Timestamp(date: date),
//            "status": "Assigned"
//        ]) { err in
//            if let err = err {
//                print("❌ Error assigning worker: \(err.localizedDescription)")
//            } else {
//                print("✅ Worker \(workerName) assigned to pickup \(pickupId)")
//            }
//        }
//    }

    func assignWorkerAndDate(pickupId: String, workerName: String, workerId: String, date: Date) {
            let db = Firestore.firestore()
            let timestamp = Timestamp(date: date)

            // 1️⃣ Update pickup with assignment details
            db.collection("pickups").document(pickupId).updateData([
                "assignedWorker": workerName,
                "assignedWorkerId": workerId,
                "status": "Assigned",
                "scheduledDate": timestamp
            ]) { error in
                if let error = error {
                    print("❌ Failed to update pickup: \(error.localizedDescription)")
                    return
                }
                print("✅ Pickup assigned to \(workerName)")
            }

            // 2️⃣ Update worker’s status and assignedPickupId
            db.collection("workers").document(workerId).updateData([
                "status": "Busy",
                "assignedPickupId": pickupId
            ]) { error in
                if let error = error {
                    print("❌ Failed to update worker status: \(error.localizedDescription)")
                }
            }

            // 3️⃣ Mirror update in 'users' collection (so RootView roles still detect correctly)
            db.collection("users").document(workerId).updateData([
                "status": "Busy",
                "assignedPickupId": pickupId
            ]) { error in
                if let error = error {
                    print("❌ Failed to update users collection: \(error.localizedDescription)")
                } else {
                    print("✅ Synced worker update to users collection")
                }
            }
        }
    
    
    func fetchPickups(forWorkerOnly: Bool = false, completion: @escaping (Bool) -> Void = { _ in }) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }

        var query: Query = db.collection("pickups").order(by: "createdAt", descending: true)

        if forWorkerOnly {
            // ✅ Filter by assignedWorkerId instead of name/email
            query = query.whereField("assignedWorkerId", isEqualTo: user.uid)
        }

        query.addSnapshotListener { snapshot, error in
            guard let docs = snapshot?.documents else {
                completion(false)
                return
            }

            self.pickups = docs.map { doc in
                let data = doc.data()
                return Pickup(
                    id: doc.documentID,
                    userId: data["userId"] as? String ?? "",
                    type: data["type"] as? String ?? "",
                    address: data["address"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    status: data["status"] as? String ?? "Scheduled",
                    assignedWorker: data["assignedWorker"] as? String ?? "",
                    scheduledDate: (data["scheduledDate"] as? Timestamp)?.dateValue(),
                    createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                )
            }
            completion(true)
        }
    }

    
    
    // MARK: - Fetch Pickups
    func fetchPickups(forUserOnly: Bool = false) {
        var query: Query = db.collection("pickups")
            .order(by: "createdAt", descending: true)

        if forUserOnly, let user = Auth.auth().currentUser {
            query = query.whereField("userId", isEqualTo: user.uid)
        }

        query.addSnapshotListener { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            self.pickups = docs.map { doc in
                let data = doc.data()
                return Pickup(
                    id: doc.documentID,
                    userId: data["userId"] as? String ?? "",
                    type: data["type"] as? String ?? "Wet",
                    address: data["address"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    status: data["status"] as? String ?? "Scheduled",
                    assignedWorker: data["assignedWorker"] as? String,
                    scheduledDate: (data["scheduledDate"] as? Timestamp)?.dateValue(),
                    createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                )
            }
        }
    }
}
