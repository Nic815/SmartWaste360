//
//  AdminBinsView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI
import FirebaseFirestore

struct AdminBinsView: View {
    @State private var bins: [Bin] = []
    @State private var newType = "Wet"
    @State private var lat = ""
    @State private var lng = ""
    let types = ["Wet", "Dry", "E-Waste"]

    var body: some View {
        VStack {
            Form {
                Picker("Bin Type", selection: $newType) {
                    ForEach(types, id: \.self) { Text($0).tag($0) }
                }

                TextField("Latitude", text: $lat).keyboardType(.decimalPad)
                TextField("Longitude", text: $lng).keyboardType(.decimalPad)

                Button("Add Bin") {
                    if let latVal = Double(lat), let lngVal = Double(lng) {
                        let newBin: [String: Any] = [
                            "lat": latVal,
                            "lng": lngVal,
                            "type": newType
                        ]
                        Firestore.firestore().collection("bins").addDocument(data: newBin)
                        lat = ""; lng = ""
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }

            List(bins) { bin in
                VStack(alignment: .leading) {
                    Text("Type: \(bin.type)")
                    Text("Lat: \(bin.lat), Lng: \(bin.lng)")
                }
            }
        }
        .navigationTitle("Admin Bins")
        .onAppear {
            Firestore.firestore().collection("bins")
                .addSnapshotListener { snapshot, _ in
                    guard let docs = snapshot?.documents else { return }
                    self.bins = docs.compactMap { try? $0.data(as: Bin.self) }
                }
        }
    }
}
