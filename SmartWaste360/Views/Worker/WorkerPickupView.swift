//
//  WorkerPickupView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//
//struct WorkerPickupView: View {
//    @StateObject var vm = PickupViewModel()
//    @State private var isLoading = true
//
//    var body: some View {
//        ScrollView {
//            if vm.pickups.isEmpty && !isLoading {
//                VStack(spacing: 10) {
//                    Image(systemName: "tray.and.arrow.down.fill")
//                        .font(.system(size: 40))
//                        .foregroundColor(.gray)
//                    Text("No assigned pickups yet")
//                        .foregroundColor(.secondary)
//                }
//                .padding(.top, 100)
//            } else {
//                LazyVStack(spacing: 16) {
//                    ForEach(vm.pickups) { p in
//                        VStack(alignment: .leading, spacing: 10) {
//                            // 🔹 Header with Type and Status
//                            HStack {
//                                Text("\(p.type) Waste")
//                                    .font(.headline)
//                                Spacer()
//                                PickupStatusBadge(status: p.status)
//                            }
//
//                            // 🔹 Address
//                            Text("📍 \(p.address)")
//                                .foregroundColor(.gray)
//                                .font(.subheadline)
//
//                            // 🔹 Description
//                            if !p.description.isEmpty {
//                                Text("📝 \(p.description)")
//                                    .font(.subheadline)
//                                    .foregroundColor(.secondary)
//                            }
//
//                            // 🔹 Scheduled Date
//                            if let date = p.scheduledDate {
//                                Text("🗓️ \(date.formatted(date: .abbreviated, time: .shortened))")
//                                    .font(.subheadline)
//                                    .foregroundColor(.secondary)
//                            }
//
//                            Divider().padding(.vertical, 4)
//
//                            // 🔹 Mark Completed Button
//                            if p.status == "Assigned" {
//                                Button(action: {
//                                    guard let workerId = Auth.auth().currentUser?.uid else { return }
//                                    let db = Firestore.firestore()
//
//                                    // 1️⃣ Mark pickup completed + add rewardGiven flag
//                                    db.collection("pickups")
//                                        .document(p.id)
//                                        .updateData([
//                                            "status": "Worker Completed",
//                                            "rewardGiven": false
//                                        ]) { err in
//                                            if let err = err {
//                                                print("❌ Error updating pickup: \(err.localizedDescription)")
//                                            } else {
//                                                print("✅ Pickup marked as Worker Completed")
//                                            }
//                                        }
//
//                                    // 2️⃣ Free up worker
//                                    db.collection("workers").document(workerId).updateData([
//                                        "status": "Available",
//                                        "assignedPickupId": ""
//                                    ]) { err in
//                                        if let err = err {
//                                            print("⚠️ Failed to update worker: \(err.localizedDescription)")
//                                        } else {
//                                            print("✅ Worker freed and marked Available")
//                                        }
//                                    }
//
//                                    // 3️⃣ Mirror in users collection
//                                    db.collection("users").document(workerId).updateData([
//                                        "status": "Available",
//                                        "assignedPickupId": ""
//                                    ]) { err in
//                                        if let err = err {
//                                            print("⚠️ Failed to update user mirror: \(err.localizedDescription)")
//                                        } else {
//                                            print("✅ User document mirrored for worker \(workerId)")
//                                        }
//                                    }
//                                }) {
//                                    HStack {
//                                        Image(systemName: "checkmark.circle.fill")
//                                        Text("Mark as Completed")
//                                            .bold()
//                                    }
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .foregroundColor(.white)
//                                    .background(
//                                        LinearGradient(colors: [.green, .mint],
//                                                       startPoint: .leading,
//                                                       endPoint: .trailing)
//                                    )
//                                    .clipShape(RoundedRectangle(cornerRadius: 12))
//                                }
//                                .shadow(color: .black.opacity(0.1), radius: 5, y: 3)
//                            }
//                            // 🔹 Completed State
//                            else if p.status == "Worker Completed" {
//                                HStack {
//                                    Image(systemName: "checkmark.seal.fill")
//                                        .foregroundColor(.green)
//                                    Text("Pickup Completed")
//                                        .font(.subheadline)
//                                        .foregroundColor(.green)
//                                }
//                                .frame(maxWidth: .infinity, alignment: .center)
//                            }
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(Color(.systemBackground))
//                        .cornerRadius(16)
//                        .shadow(color: .black.opacity(0.05), radius: 4, y: 3)
//                        .padding(.horizontal)
//                    }
//                }
//                .padding(.vertical)
//            }
//        }
//        .navigationTitle("Assigned Pickups")
//        .onAppear {
//            vm.fetchPickups(forWorkerOnly: true) { finished in
//                isLoading = false
//            }
//        }
//    }
//}
//
//// 🔹 Status Badge View
//struct PickupStatusBadge: View {
//    let status: String
//    var body: some View {
//        let (color, text) = badgeStyle(for: status)
//        return Text(text)
//            .font(.caption.bold())
//            .padding(.horizontal, 10)
//            .padding(.vertical, 4)
//            .background(color.opacity(0.15))
//            .foregroundColor(color)
//            .cornerRadius(8)
//    }
//
//    private func badgeStyle(for status: String) -> (Color, String) {
//        switch status {
//        case "Assigned": return (.blue, "Assigned")
//        case "Worker Completed": return (.green, "Completed")
//        default: return (.orange, "Scheduled")
//        }
//    }
//}

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct WorkerPickupView: View {
    @StateObject var pickupVM = PickupViewModel()
    @StateObject var complaintVM = ComplaintViewModel()
    @State private var isLoading = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // 🟢 Pickups Section
                if pickupVM.pickups.isEmpty && !isLoading {
                    EmptySectionView(icon: "truck.box.fill", message: "No assigned pickups yet")
                } else {
                    SectionHeader(title: "Assigned Pickups", icon: "truck.box.fill", color: .green)
                    LazyVStack(spacing: 16) {
                        ForEach(pickupVM.pickups) { p in
                            PickupCard(p: p, vm: pickupVM)
                        }
                    }
                }

                Divider().padding(.vertical, 10)

                // 🔵 Complaints Section
                if complaintVM.complaints.isEmpty && !isLoading {
                    EmptySectionView(icon: "exclamationmark.bubble.fill", message: "No assigned complaints yet")
                } else {
                    SectionHeader(title: "Assigned Complaints", icon: "exclamationmark.bubble.fill", color: .blue)
                    LazyVStack(spacing: 16) {
                        ForEach(complaintVM.complaints) { c in
                            ComplaintCardForWorker(complaint: c)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("My Tasks")
        .onAppear {
            pickupVM.fetchPickups(forWorkerOnly: true) { _ in
                complaintVM.fetchComplaints(forWorkerOnly: true) { _ in
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Pickup Card (unchanged except struct name)
struct PickupCard: View {
    let p: Pickup
    var vm: PickupViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(p.type) Waste")
                    .font(.headline)
                Spacer()
                PickupStatusBadge(status: p.status)
            }

            Text("Location: \(p.address)")
                .foregroundColor(.gray)
                .font(.subheadline)

            if !p.description.isEmpty {
                Text("Description: \(p.description)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if let date = p.scheduledDate {
                Text("Scheduled: \(date.formatted(date: .abbreviated, time: .shortened))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Divider().padding(.vertical, 4)

            if p.status == "Assigned" {
                Button(action: {
                    Firestore.firestore()
                        .collection("pickups")
                        .document(p.id)
                        .updateData(["status": "Worker Completed"])
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Mark as Completed").bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(colors: [.green, .mint],
                                               startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            } else if p.status == "Worker Completed" {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Text("Pickup Completed")
                        .font(.subheadline)
                        .foregroundColor(.green)
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

// MARK: - Complaint Card
struct ComplaintCardForWorker: View {
    let complaint: Complaint

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let img = complaint.uiImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 3)
            }

            Text("Description: \(complaint.description)")
                .font(.headline)
            Text("Location: \(complaint.id.prefix(8))") // or add address field if you have it
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let date = complaint.assignedDate {
                Text("Assigned on: \(date.formatted(date: .abbreviated, time: .shortened))")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }

            Divider().padding(.vertical, 4)

            if !complaint.workerCompleted {
                Button(action: {
                    Firestore.firestore().collection("complaints")
                        .document(complaint.id)
                        .updateData(["workerCompleted": true])
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Mark as Completed").bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(colors: [.green, .mint],
                                               startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            } else {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Text("Complaint Completed")
                        .foregroundColor(.green)
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

// MARK: - Reusable Section header and empty view
struct SectionHeader: View {
    let title: String
    let icon: String
    let color: Color
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(title)
                .font(.title3.bold())
            Spacer()
        }
        .padding(.horizontal)
    }
}


    
    struct EmptySectionView: View {
        let icon: String
        let message: String
        var body: some View {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                Text(message)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 60)
        }
    }

struct PickupStatusBadge: View {
    let status: String
    var body: some View {
        let (color, text) = badgeStyle(for: status)
        return Text(text)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(8)
    }

    private func badgeStyle(for status: String) -> (Color, String) {
        switch status {
        case "Assigned": return (.blue, "Assigned")
        case "Worker Completed": return (.green, "Completed")
        default: return (.orange, "Scheduled")
        }
    }
}
