//
//  RewardViewModel.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//


//import Foundation
//import FirebaseFirestore
//
//struct RewardItem: Identifiable {
//    let id: String
//    let type: String         // "pickup" or "ewaste"
//    let userId: String
//    let address: String
//    let description: String?
//    let imageBase64: String?
//    var status: String
//    let createdAt: Date
//
//    var uiImage: UIImage? {
//        guard let base64 = imageBase64,
//              let data = Data(base64Encoded: base64) else { return nil }
//        return UIImage(data: data)
//    }
//}
//
//class RewardViewModel: ObservableObject {
//    @Published var pendingRewards: [RewardItem] = []
//    private let db = Firestore.firestore()
//
//    func fetchPendingRewards() {
//        var temp: [RewardItem] = []
//
//        // 🟢 Fetch pickups
//        db.collection("pickups")
//            .whereField("status", isEqualTo: "Worker Completed")
//            .whereField("rewardGiven", isEqualTo: false)
//            .getDocuments { snap, err in
//                guard let docs = snap?.documents else { return }
//                for doc in docs {
//                    let d = doc.data()
//                    temp.append(RewardItem(
//                        id: doc.documentID,
//                        type: "pickup",
//                        userId: d["userId"] as? String ?? "",
//                        address: d["address"] as? String ?? "",
//                        description: d["description"] as? String ?? "",
//                        imageBase64: d["imageBase64"] as? String ?? "",
//                        status: d["status"] as? String ?? "",
//                        createdAt: (d["createdAt"] as? Timestamp)?.dateValue() ?? Date()
//                    ))
//                }
//
//                // 🟠 Fetch e-waste
//                self.db.collection("ewaste")
//                    .whereField("status", isEqualTo: "Worker Completed")
//                    .whereField("rewardGiven", isEqualTo: false)
//                    .getDocuments { snap2, err2 in
//                        guard let docs2 = snap2?.documents else { return }
//                        for doc in docs2 {
//                            let d = doc.data()
//                            temp.append(RewardItem(
//                                id: doc.documentID,
//                                type: "ewaste",
//                                userId: d["userId"] as? String ?? "",
//                                address: d["address"] as? String ?? "",
//                                description: d["itemName"] as? String ?? "",
//                                imageBase64: d["imageBase64"] as? String ?? "",
//                                status: d["status"] as? String ?? "",
//                                createdAt: (d["createdAt"] as? Timestamp)?.dateValue() ?? Date()
//                            ))
//                        }
//
//                        DispatchQueue.main.async {
//                            self.pendingRewards = temp.sorted { $0.createdAt > $1.createdAt }
//                        }
//                    }
//            }
//    }
//
//    
//    // 🪙 Reward citizen (+5 points)
////    func rewardCitizen(for item: RewardItem) {
////        let userRef = db.collection("users").document(item.userId)
////        let collectionName = item.type == "pickup" ? "pickups" : "ewaste"
////
////        db.runTransaction({ (transaction, errorPointer) -> Any? in
////            do {
////                let snapshot = try transaction.getDocument(userRef)
////                let currentPoints = snapshot.data()?["points"] as? Int ?? 0
////                transaction.updateData(["points": currentPoints + 5], forDocument: userRef)
////            } catch let err {
////                errorPointer?.pointee = err as NSError
////                return nil
////            }
////            return nil
////        }) { (_, error) in
////            if let error = error {
////                print("❌ Reward failed:", error.localizedDescription)
////                return
////            }
////
////            // Mark as rewarded in the respective collection
////            self.db.collection(collectionName).document(item.id)
////                .updateData(["rewardGiven": true]) { _ in
////                    DispatchQueue.main.async {
////                        self.pendingRewards.removeAll { $0.id == item.id }
////                    }
////                }
////
////            print("✅ Reward added (+5 pts) to citizen \(item.userId)")
////        }
////    }
//
//    // 🪙 Reward citizen (+5 points)
//    func rewardCitizen(for item: RewardItem) {
//        let userRef = db.collection("users").document(item.userId)
//        let collectionName = item.type == "pickup" ? "pickups" : "ewaste"
//
//        db.runTransaction({ (transaction, errorPointer) -> Any? in
//            do {
//                let snapshot = try transaction.getDocument(userRef)
//                let currentPoints = snapshot.data()?["points"] as? Int ?? 0
//                transaction.updateData(["points": currentPoints + 5], forDocument: userRef)
//            } catch let err {
//                errorPointer?.pointee = err as NSError
//                return nil
//            }
//            return nil
//        }) { (_, error) in
//            if let error = error {
//                print("❌ Reward failed:", error.localizedDescription)
//                return
//            }
//
//            // ✅ Mark as rewarded but keep it in the list
//            self.db.collection(collectionName).document(item.id)
//                .updateData(["rewardGiven": true]) { _ in
//                    DispatchQueue.main.async {
//                        // Instead of removing it, mark as rewarded locally
//                        if let index = self.pendingRewards.firstIndex(where: { $0.id == item.id }) {
//                            var updated = self.pendingRewards[index]
//                            updated.status = "Rewarded"
//                            self.pendingRewards[index] = updated
//                        }
//                    }
//                }
//
//            print("✅ Reward added (+5 pts) to citizen \(item.userId)")
//        }
//    }
//
//    
//}

//import Foundation
//import FirebaseFirestore
//import UIKit
//
//struct RewardItem: Identifiable {
//    let id: String
//    let type: String         // "pickup" or "ewaste"
//    let userId: String
//    let address: String
//    let description: String?
//    let imageBase64: String?
//    var rewardGiven: Bool
//    let status: String
//    let createdAt: Date
//
//    var uiImage: UIImage? {
//        guard let base64 = imageBase64,
//              let data = Data(base64Encoded: base64) else { return nil }
//        return UIImage(data: data)
//    }
//}
//
//class RewardViewModel: ObservableObject {
//    @Published var allRewards: [RewardItem] = []
//    @Published var filter: RewardFilter = .all
//    
//    private let db = Firestore.firestore()
//    
//    enum RewardFilter: String, CaseIterable {
//        case all = "All"
//        case pending = "Pending"
//        case rewarded = "Rewarded"
//    }
//
//    // 🟩 Fetch all completed items (rewarded + unrewarded)
//    func fetchAllRewards() {
//        var combined: [RewardItem] = []
//
//        // Fetch pickups
//        db.collection("pickups")
//            .whereField("status", in: ["Worker Completed", "Completed"])
//            .getDocuments { snap, err in
//                guard let docs = snap?.documents else { return }
//
//                for doc in docs {
//                    let d = doc.data()
//                    combined.append(
//                        RewardItem(
//                            id: doc.documentID,
//                            type: "pickup",
//                            userId: d["userId"] as? String ?? "",
//                            address: d["address"] as? String ?? "",
//                            description: d["description"] as? String ?? "",
//                            imageBase64: d["imageBase64"] as? String ?? "",
//                            rewardGiven: d["rewardGiven"] as? Bool ?? false,
//                            status: d["status"] as? String ?? "",
//                            createdAt: (d["createdAt"] as? Timestamp)?.dateValue() ?? Date()
//                        )
//                    )
//                }
//
//                // Fetch e-waste
//                self.db.collection("ewaste")
//                    .whereField("status", in: ["Worker Completed", "Completed"])
//                    .getDocuments { snap2, err2 in
//                        guard let docs2 = snap2?.documents else { return }
//
//                        for doc in docs2 {
//                            let d = doc.data()
//                            combined.append(
//                                RewardItem(
//                                    id: doc.documentID,
//                                    type: "ewaste",
//                                    userId: d["userId"] as? String ?? "",
//                                    address: d["address"] as? String ?? "",
//                                    description: d["itemName"] as? String ?? "",
//                                    imageBase64: d["imageBase64"] as? String ?? "",
//                                    rewardGiven: d["rewardGiven"] as? Bool ?? false,
//                                    status: d["status"] as? String ?? "",
//                                    createdAt: (d["createdAt"] as? Timestamp)?.dateValue() ?? Date()
//                                )
//                            )
//                        }
//
//                        // Sort: unrewarded first, rewarded last
//                        DispatchQueue.main.async {
//                            self.allRewards = combined.sorted {
//                                if $0.rewardGiven == $1.rewardGiven {
//                                    return $0.createdAt > $1.createdAt
//                                } else {
//                                    return !$0.rewardGiven && $1.rewardGiven
//                                }
//                            }
//                        }
//                    }
//            }
//    }
//
//    // 🪙 Reward citizen (+5 points)
//    func rewardCitizen(for item: RewardItem) {
//        let userRef = db.collection("users").document(item.userId)
//        let collectionName = item.type == "pickup" ? "pickups" : "ewaste"
//
//        db.runTransaction({ (transaction, errorPointer) -> Any? in
//            do {
//                let snapshot = try transaction.getDocument(userRef)
//                let currentPoints = snapshot.data()?["points"] as? Int ?? 0
//                transaction.updateData(["points": currentPoints + 5], forDocument: userRef)
//            } catch let err {
//                errorPointer?.pointee = err as NSError
//                return nil
//            }
//            return nil
//        }) { (_, error) in
//            if let error = error {
//                print("❌ Reward failed:", error.localizedDescription)
//                return
//            }
//
//            self.db.collection(collectionName).document(item.id)
//                .updateData(["rewardGiven": true]) { _ in
//                    DispatchQueue.main.async {
//                        if let index = self.allRewards.firstIndex(where: { $0.id == item.id }) {
//                            self.allRewards[index].rewardGiven = true
//                        }
//                    }
//                }
//
//            print("✅ Reward added (+5 pts) to citizen \(item.userId)")
//        }
//    }
//
//    // 🧮 Filtered rewards for UI
//    var filteredRewards: [RewardItem] {
//        switch filter {
//        case .all:
//            return allRewards
//        case .pending:
//            return allRewards.filter { !$0.rewardGiven }
//        case .rewarded:
//            return allRewards.filter { $0.rewardGiven }
//        }
//    }
//
//    // 🧩 Count badges
//    var allCount: Int { allRewards.count }
//    var pendingCount: Int { allRewards.filter { !$0.rewardGiven }.count }
//    var rewardedCount: Int { allRewards.filter { $0.rewardGiven }.count }
//}

import Foundation
import FirebaseFirestore
import UIKit

// MARK: - RewardItem
struct RewardItem: Identifiable {
    let id: String
    let type: String         // "pickup", "ewaste", or "complaint"
    let userId: String
    let address: String
    let description: String?
    let imageBase64: String?
    var rewardGiven: Bool
    let status: String
    let createdAt: Date

    var uiImage: UIImage? {
        guard let base64 = imageBase64,
              let data = Data(base64Encoded: base64) else { return nil }
        return UIImage(data: data)
    }
}

// MARK: - ViewModel
class RewardViewModel: ObservableObject {
    @Published var allRewards: [RewardItem] = []
    @Published var filter: RewardFilter = .all

    private let db = Firestore.firestore()

    enum RewardFilter: String, CaseIterable {
        case all = "All"
        case pending = "Pending"
        case rewarded = "Rewarded"
    }

    // MARK: - Fetch All (Pickups + E-Waste + Complaints)
    func fetchAllRewards() {
        var combined: [RewardItem] = []

        // 🔹 Fetch Pickups
        db.collection("pickups")
            .whereField("status", in: ["Worker Completed", "Completed"])
            .getDocuments { snap, err in
                guard let docs = snap?.documents else { return }

                for doc in docs {
                    let d = doc.data()
                    combined.append(
                        RewardItem(
                            id: doc.documentID,
                            type: "pickup",
                            userId: d["userId"] as? String ?? "",
                            address: d["address"] as? String ?? "",
                            description: d["description"] as? String ?? "",
                            imageBase64: d["imageBase64"] as? String ?? "",
                            rewardGiven: d["rewardGiven"] as? Bool ?? false,
                            status: d["status"] as? String ?? "",
                            createdAt: (d["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                        )
                    )
                }

                // 🔹 Fetch E-Waste
                self.db.collection("ewaste")
                    .whereField("status", in: ["Worker Completed", "Completed"])
                    .getDocuments { snap2, err2 in
                        guard let docs2 = snap2?.documents else { return }

                        for doc in docs2 {
                            let d = doc.data()
                            combined.append(
                                RewardItem(
                                    id: doc.documentID,
                                    type: "ewaste",
                                    userId: d["userId"] as? String ?? "",
                                    address: d["address"] as? String ?? "",
                                    description: d["itemName"] as? String ?? "",
                                    imageBase64: d["imageBase64"] as? String ?? "",
                                    rewardGiven: d["rewardGiven"] as? Bool ?? false,
                                    status: d["status"] as? String ?? "",
                                    createdAt: (d["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                                )
                            )
                        }

                        // 🔹 Fetch Complaints (new addition)
                        self.db.collection("complaints")
                            .whereField("status", isEqualTo: "Resolved")
                            .getDocuments { snap3, err3 in
                                guard let docs3 = snap3?.documents else { return }

                                for doc in docs3 {
                                    let d = doc.data()
                                    combined.append(
                                        RewardItem(
                                            id: doc.documentID,
                                            type: "complaint",
                                            userId: d["userId"] as? String ?? "",
                                            address: "Complaint ID: \(doc.documentID.prefix(8))",
                                            description: d["description"] as? String ?? "",
                                            imageBase64: d["imageBase64"] as? String ?? "",
                                            rewardGiven: d["rewardGiven"] as? Bool ?? false,
                                            status: d["status"] as? String ?? "",
                                            createdAt: (d["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                                        )
                                    )
                                }

                                // ✅ Sort by createdAt + rewardGiven priority
                                DispatchQueue.main.async {
                                    self.allRewards = combined.sorted {
                                        if $0.rewardGiven == $1.rewardGiven {
                                            return $0.createdAt > $1.createdAt
                                        } else {
                                            return !$0.rewardGiven && $1.rewardGiven
                                        }
                                    }
                                }
                            }
                    }
            }
    }

    // MARK: - Reward Citizen (+5 points)
    func rewardCitizen(for item: RewardItem) {
        let userRef = db.collection("users").document(item.userId)
        let collectionName: String

        switch item.type {
        case "pickup": collectionName = "pickups"
        case "ewaste": collectionName = "ewaste"
        case "complaint": collectionName = "complaints"
        default: return
        }

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                let snapshot = try transaction.getDocument(userRef)
                let currentPoints = snapshot.data()?["points"] as? Int ?? 0
                transaction.updateData(["points": currentPoints + 5], forDocument: userRef)
            } catch let err {
                errorPointer?.pointee = err as NSError
                return nil
            }
            return nil
        }) { (_, error) in
            if let error = error {
                print("❌ Reward failed:", error.localizedDescription)
                return
            }

            // ✅ Mark as rewarded in corresponding collection
            self.db.collection(collectionName).document(item.id)
                .updateData(["rewardGiven": true]) { _ in
                    DispatchQueue.main.async {
                        if let index = self.allRewards.firstIndex(where: { $0.id == item.id }) {
                            self.allRewards[index].rewardGiven = true
                        }
                    }
                }

            print("✅ Reward added (+5 pts) to citizen \(item.userId) for \(item.type)")
        }
    }

    // MARK: - Filtered rewards for UI
    var filteredRewards: [RewardItem] {
        switch filter {
        case .all:
            return allRewards
        case .pending:
            return allRewards.filter { !$0.rewardGiven }
        case .rewarded:
            return allRewards.filter { $0.rewardGiven }
        }
    }

    // MARK: - Count badges
    var allCount: Int { allRewards.count }
    var pendingCount: Int { allRewards.filter { !$0.rewardGiven }.count }
    var rewardedCount: Int { allRewards.filter { $0.rewardGiven }.count }
}
