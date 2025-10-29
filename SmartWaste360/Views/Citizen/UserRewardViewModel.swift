//
//  UserRewardViewModel.swift
//  SmartWaste360
//
//  Created by NIKHIL on 16/10/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserRewardViewModel: ObservableObject {
    @Published var points: Int = 0

    private let db = Firestore.firestore()

    func fetchPoints() {
        guard let user = Auth.auth().currentUser else { return }

        db.collection("users").document(user.uid).addSnapshotListener { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            DispatchQueue.main.async {
                self.points = data["points"] as? Int ?? 0
            }
        }
    }
}

