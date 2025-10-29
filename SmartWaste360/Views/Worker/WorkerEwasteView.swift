//
//  WorkerEwasteView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct WorkerEwasteView: View {
    @StateObject var vm = EwasteViewModel()
    @State private var isLoading = true

    var body: some View {
        ScrollView {
            if vm.ewastes.isEmpty && !isLoading {
                VStack(spacing: 10) {
                    Image(systemName: "tray.and.arrow.down.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("No assigned e-waste tasks yet")
                        .foregroundColor(.secondary)
                }
                .padding(.top, 100)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(vm.ewastes) { e in
                        VStack(alignment: .leading, spacing: 10) {
                            // 🔹 Header
                            HStack {
                                Text(e.itemName)
                                    .font(.headline)
                                Spacer()
                                EwasteStatusBadgeeee(status: e.status)
                            }

                            // 🔹 Address
                            Text("📍 \(e.address)")
                                .foregroundColor(.gray)
                                .font(.subheadline)

                            // 🔹 Condition
                            Text("Condition: \(e.isWorking ? "Working" : "Not Working")")
                                .foregroundColor(e.isWorking ? .green : .orange)
                                .font(.subheadline)

                            // 🔹 Date
                            if let date = e.scheduledDate {
                                Text("🗓️ Pickup: \(date.formatted(date: .abbreviated, time: .shortened))")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }

                            // 🔹 Image
                            if let img = e.uiImage {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(radius: 4)
                            }

                            Divider().padding(.vertical, 4)

                            // 🔹 Mark as Completed Button
                            if e.status == "Assigned" {
                                Button(action: {
                                    guard let workerId = Auth.auth().currentUser?.uid else { return }
                                    let db = Firestore.firestore()

                                    // 1️⃣ Update E-Waste document
                                    db.collection("ewaste")
                                        .document(e.id)
                                        .updateData([
                                            "workerCompleted": true,
                                            "status": "Worker Completed",
                                            "rewardGiven": false
                                        ]) { err in
                                            if let err = err {
                                                print("❌ Error updating ewaste: \(err.localizedDescription)")
                                            } else {
                                                print("✅ E-waste marked as Worker Completed")
                                            }
                                        }

                                    // 2️⃣ Free up the worker in /workers
                                    db.collection("workers").document(workerId).updateData([
                                        "status": "Available",
                                        "assignedEwasteId": ""
                                    ]) { err in
                                        if let err = err {
                                            print("⚠️ Failed to update worker: \(err.localizedDescription)")
                                        } else {
                                            print("✅ Worker freed and marked Available")
                                        }
                                    }

                                    // 3️⃣ Mirror same change in /users
                                    db.collection("users").document(workerId).updateData([
                                        "status": "Available",
                                        "assignedEwasteId": ""
                                    ]) { err in
                                        if let err = err {
                                            print("⚠️ Failed to update user mirror: \(err.localizedDescription)")
                                        } else {
                                            print("✅ User document mirrored for worker \(workerId)")
                                        }
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                        Text("Mark as Completed").bold()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(
                                        LinearGradient(colors: [.green, .mint],
                                                       startPoint: .leading,
                                                       endPoint: .trailing)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .shadow(color: .black.opacity(0.1), radius: 5, y: 3)
                            }
                            // 🔹 Completed State
                            else if e.status == "Worker Completed" || e.workerCompleted {
                                HStack {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(.green)
                                    Text("Pickup Completed")
                                        .foregroundColor(.green)
                                        .font(.subheadline)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 3)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Assigned E-Waste")
        .onAppear {
            vm.fetchEwaste(forWorkerOnly: true) { done in
                isLoading = false
            }
        }
    }
}

// 🔹 Status Badge View (for E-Waste)
struct EwasteStatusBadgeeee: View {
    let status: String
    var body: some View {
        let (color, text) = badgeStyle(for: status)
        return Text(text)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(8)
    }

    private func badgeStyle(for status: String) -> (Color, String) {
        switch status {
        case "Completed", "Worker Completed": return (.green, "Completed")
        case "Assigned":  return (.blue,  "Assigned")
        case "Registered":return (.orange,"Registered")
        default:          return (.gray,  "Pending")
        }
    }
}
