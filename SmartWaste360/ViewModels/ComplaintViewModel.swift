//
//  ComplaintViewModel.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class ComplaintViewModel: ObservableObject {
    @Published var complaints: [Complaint] = []
    private let db = Firestore.firestore()

    // MARK: Submit Complaint
    func submitComplaint(description: String,
                         image: UIImage,
                         completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }

        // Convert image → Base64 string
        guard let imageData = image.jpegData(compressionQuality: 0.6) else {
            completion(false)
            return
        }
        let base64String = imageData.base64EncodedString()

        let newComplaint: [String: Any] = [
            "userId": user.uid,
            "description": description,
            "imageBase64": base64String,
            "status": "Submitted",
            "escalationLevel": 0,
            "rewardGiven": false,
            "createdAt": Timestamp(date: Date()),
            //New
            "assignedWorker": "",
            "assignedWorkerId": "",
            "assignedDate": NSNull(),
            "workerCompleted": false
        ]

        db.collection("complaints").addDocument(data: newComplaint) { err in
            if let err = err {
                print("❌ Error saving complaint: \(err.localizedDescription)")
                completion(false)
            } else {
                print("✅ Complaint saved")
                completion(true)
            }
        }
    }

    func assignWorkerAndDate(complaintId: String, workerName: String, workerId: String, date: Date) {
        let db = Firestore.firestore()
        db.collection("complaints").document(complaintId).updateData([
            "assignedWorker": workerName,
            "assignedWorkerId": workerId,
            "assignedDate": Timestamp(date: date),
            "status": "Assigned"
        ]) { err in
            if let err = err {
                print("❌ Error assigning worker: \(err.localizedDescription)")
            } else {
                db.collection("workers").document(workerId).updateData(["status": "Busy"])
                print("✅ Worker \(workerName) assigned to complaint \(complaintId)")
            }
        }
    }
    
    

        // Existing fetchComplaints()
        func fetchComplaints(forWorkerOnly: Bool = false, completion: @escaping (Bool) -> Void = { _ in }) {
            guard let user = Auth.auth().currentUser else {
                completion(false)
                return
            }

            var query: Query = db.collection("complaints").order(by: "createdAt", descending: true)

            if forWorkerOnly {
                // ✅ Only assigned to this worker
                query = query.whereField("assignedWorkerId", isEqualTo: user.uid)
            }

            query.addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else {
                    completion(false)
                    return
                }

                self.complaints = docs.map { doc in
                    let d = doc.data()
                    return Complaint(
                        id: doc.documentID,
                        userId: d["userId"] as? String ?? "",
                        description: d["description"] as? String ?? "",
                        imageBase64: d["imageBase64"] as? String ?? "",
                        status: d["status"] as? String ?? "Submitted",
                        escalationLevel: d["escalationLevel"] as? Int ?? 0,
                        createdAt: (d["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                        assignedWorker: d["assignedWorker"] as? String,
                        assignedWorkerId: d["assignedWorkerId"] as? String,
                        assignedDate: (d["assignedDate"] as? Timestamp)?.dateValue(),
                        workerCompleted: d["workerCompleted"] as? Bool ?? false
                    )
                }
                completion(true)
            }
        }
    
    

    
    
    // MARK: Fetch Complaints
    func fetchComplaints(forUserOnly: Bool = false) {
        var query: Query = db.collection("complaints")
            .order(by: "createdAt", descending: true)

        if forUserOnly, let user = Auth.auth().currentUser {
            query = query.whereField("userId", isEqualTo: user.uid)
        }

        query.addSnapshotListener { snapshot, error in
            guard let docs = snapshot?.documents else { return }

            self.complaints = docs.map { doc in
                        let d = doc.data()
                        return Complaint(
                            id: doc.documentID,
                            userId: d["userId"] as? String ?? "",
                            description: d["description"] as? String ?? "",
                            imageBase64: d["imageBase64"] as? String ?? "",
                            status: d["status"] as? String ?? "Submitted",
                            escalationLevel: d["escalationLevel"] as? Int ?? 0,
                            createdAt: (d["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                            assignedWorker: d["assignedWorker"] as? String,
                            assignedWorkerId: d["assignedWorkerId"] as? String,
                            assignedDate: (d["assignedDate"] as? Timestamp)?.dateValue(),
                            workerCompleted: d["workerCompleted"] as? Bool ?? false

                        )
                    }
        }
    }
}
extension ComplaintViewModel {
    func autoEscalateComplaints() {
        let db = Firestore.firestore()
        let now = Date()

        db.collection("complaints")
            .whereField("status", isNotEqualTo: "Resolved")
            .getDocuments { snapshot, error in
                guard let docs = snapshot?.documents else { return }

                for doc in docs {
                    let data = doc.data()
                    let id = doc.documentID

                    let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                    let escalationLevel = data["escalationLevel"] as? Int ?? 0

                    let hoursSinceCreation = now.timeIntervalSince(createdAt) / 3600

                    var newLevel = escalationLevel
                    var escalatedTo = ""

                    // 🔹 Reversed escalation order
                    if hoursSinceCreation >= 72 && escalationLevel < 3 {
                        newLevel = 3
                        escalatedTo = "Supervisor"
                    } else if hoursSinceCreation >= 48 && escalationLevel < 2 {
                        newLevel = 2
                        escalatedTo = "Manager"
                    } else if hoursSinceCreation >= 24 && escalationLevel < 1 {
                        newLevel = 1
                        escalatedTo = "Admin"
                    }

                    // 🔹 If escalation occurred, update Firestore
                    if newLevel != escalationLevel {
                        db.collection("complaints").document(id)
                            .updateData(["escalationLevel": newLevel]) { err in
                                if let err = err {
                                    print("❌ Failed to escalate \(id): \(err.localizedDescription)")
                                } else {
                                    print("⚠️ Complaint \(id) escalated to \(escalatedTo) (Level \(newLevel))")
                                }
                            }
                    }
                }
            }
    }
}
