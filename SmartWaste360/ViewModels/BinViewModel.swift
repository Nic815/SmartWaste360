//
//  BinViewModel.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import Foundation
import FirebaseFirestore

class BinViewModel: ObservableObject {
    @Published var bins: [Bin] = []
    private let db = Firestore.firestore()

    // MARK: - Fetch All Bins
    func fetchBins() {
        db.collection("bins").addSnapshotListener { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            self.bins = docs.compactMap { try? $0.data(as: Bin.self) }
        }
    }
}
