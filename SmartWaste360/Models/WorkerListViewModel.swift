//
//  WorkerListViewModel.swift
//  SmartWaste360
//
//  Created by NIKHIL on 15/10/25.
//

import Foundation
import FirebaseFirestore

class WorkerListViewModel: ObservableObject {
    @Published var workers: [Worker] = []
    private let db = Firestore.firestore()

    func fetchAllWorkers() {
        db.collection("workers").getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            self.workers = docs.map { doc in
                let data = doc.data()
                return Worker(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    phone: data["phone"] as? String ?? "",
                    address: data["address"] as? String ?? "",
                    status: data["status"] as? String ?? "Available"
                )
            }
        }
    }
}




// Worker model
//struct Worker: Identifiable {
//    var id: String
//    var name: String
//    var email: String
//    var phone: String
//    var address: String
//    var status: String
//}
