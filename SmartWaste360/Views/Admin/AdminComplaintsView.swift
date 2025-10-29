//
//  AdminComplaintsView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

//import SwiftUI
//import Foundation
//import FirebaseFirestore
//import FirebaseAuth
//
//struct AdminComplaintsView: View {
//    @StateObject var vm = ComplaintViewModel()
//    
////    func addRewardGivenFieldToExistingDocs() {
////        let db = Firestore.firestore()
////
////        // ✅ Pickups
////        db.collection("pickups").getDocuments { snapshot, error in
////            guard let docs = snapshot?.documents else { return }
////            for doc in docs {
////                if doc.data()["rewardGiven"] == nil {
////                    db.collection("pickups").document(doc.documentID).updateData(["rewardGiven": false])
////                }
////            }
////        }
////
////        // ✅ E-Waste
////        db.collection("ewaste").getDocuments { snapshot, error in
////            guard let docs = snapshot?.documents else { return }
////            for doc in docs {
////                if doc.data()["rewardGiven"] == nil {
////                    db.collection("ewaste").document(doc.documentID).updateData(["rewardGiven": false])
////                }
////            }
////        }
////
////        // ✅ Complaints
////        db.collection("complaints").getDocuments { snapshot, error in
////            guard let docs = snapshot?.documents else { return }
////            for doc in docs {
////                if doc.data()["rewardGiven"] == nil {
////                    db.collection("complaints").document(doc.documentID).updateData(["rewardGiven": false])
////                }
////            }
////        }
////
////        print("✅ rewardGiven field added where missing in pickups, ewaste, and complaints.")
////    }
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 16) {
//                ForEach(vm.complaints) { c in
//                    VStack(alignment: .leading, spacing: 12) {
//                        
//                        // 🔹 Complaint image
//                        if let img = c.uiImage {
//                            Image(uiImage: img)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(height: 160)
//                                .frame(maxWidth: .infinity)
//                                .clipShape(RoundedRectangle(cornerRadius: 12))
//                                .shadow(radius: 4)
//                        }
//                        
//                        
//                        // 🔹 Description + Status
//                        HStack {
//                            Text(c.description)
//                                .font(.headline)
//                                .foregroundColor(.primary)
//                                .lineLimit(2)
//                                .multilineTextAlignment(.leading)
//                            Spacer()
//                            StatusBadgge(status: c.status)
//                        }
//                        
//                        // 🔹 Escalation level
//                        if c.escalationLevel > 0 {
//                            Text("⚠️ Escalation Level: \(c.escalationLevel)")
//                                .font(.caption.bold())
//                                .foregroundColor(.red)
//                        }
//                        
//                    
//                        
//                        // 🔹 Created date
//                        Text("Filed on \(c.createdAt.formatted(date: .abbreviated, time: .shortened))")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                        
//                        // 🔹 Action button
//                        if c.status != "Resolved" {
//                            HStack {
//                                Spacer() // 👈 Centers the button
//                                Button(action: {
//                                    Firestore.firestore().collection("complaints")
//                                        .document(c.id)
//                                        .updateData(["status": "Resolved"])
//                                }) {
//                                    Text("Mark as Resolved")
//                                        .bold()
//                                        .frame(width: 160) // 👈 smaller, fixed size
//                                        .padding(.vertical, 8)
//                                        .foregroundColor(.white)
//                                        .background(
//                                            LinearGradient(colors: [.green, .mint],
//                                                           startPoint: .leading,
//                                                           endPoint: .trailing)
//                                        )
//                                        .clipShape(RoundedRectangle(cornerRadius: 12))
//                                        .shadow(color: .black.opacity(0.15), radius: 6, y: 4)
//                                }
//                                Spacer()
//                            }
//                            .padding(.top, 6)
//                        }
//                        
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .background(Color(.systemBackground))
//                    .cornerRadius(16)
//                    .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
//                    .padding(.horizontal)
//                }
//            }
//            .padding(.vertical)
//        }
//        .navigationTitle("Manage Complaints")
//        .onAppear {
//            vm.fetchComplaints()
//            
//        }
//    }
//}
//
//// ✅ Reuse the StatusBadge we built earlier
//struct StatusBadgge: View {
//    let status: String
//    
//    var body: some View {
//        let (color, text) = badgeStyle(for: status)
//        return Text(text)
//            .font(.caption.bold())
//            .padding(.horizontal, 10)
//            .padding(.vertical, 5)
//            .background(color.opacity(0.15))
//            .foregroundColor(color)
//            .cornerRadius(8)
//    }
//    
//    private func badgeStyle(for status: String) -> (Color, String) {
//        switch status {
//        case "Resolved":
//            return (.green, "Resolved")
//        case "In Progress":
//            return (.orange, "In Progress")
//        default:
//            return (.blue, "Submitted")
//        }
//    }
//}
import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseAuth

struct AdminComplaintsView: View {
    
    
    @StateObject var vm = ComplaintViewModel()
    @State private var selectedWorker: Worker? = nil
    @State private var selectedDate = Date()
    @State private var showWorkerSheet = false
    

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(vm.complaints) { c in
                    ComplaintCardView(
                        complaint: c,
                        selectedWorker: $selectedWorker,
                        selectedDate: $selectedDate,
                        showWorkerSheet: $showWorkerSheet,
                        vm: vm
                    )
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Manage Complaints")
        .onAppear {
            vm.fetchComplaints()
            vm.autoEscalateComplaints()
            
        }
        .sheet(isPresented: $showWorkerSheet) {
            // ✅ Reuse your existing WorkerSelectionSheet
            WorkerSelectionSheet(vm: WorkerListViewModel()) { worker in
                selectedWorker = worker
                showWorkerSheet = false
            }
        }
    }
}

struct ComplaintCardView: View {
    let complaint: Complaint
    @Binding var selectedWorker: Worker?
    @Binding var selectedDate: Date
    @Binding var showWorkerSheet: Bool
    @ObservedObject var vm: ComplaintViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 🔹 Image
            if let img = complaint.uiImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 4)
            }

            // 🔹 Description + Status
            HStack {
                Text(complaint.description)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Spacer()
                StatusBadge(status: complaint.status)
            }

            // 🔹 Escalation level (if any)
            if complaint.escalationLevel > 0 {
                Text("Escalation Level: \(complaint.escalationLevel)")
                    .font(.caption.bold())
                    .foregroundColor(.red)
            }

            // 🔹 Created date
            Text("Filed on \(complaint.createdAt.formatted(date: .abbreviated, time: .shortened))")
                .font(.caption)
                .foregroundColor(.secondary)

            Divider()

            // 🔹 Worker info
            if let workerName = complaint.assignedWorker, !workerName.isEmpty {
                HStack {
                    Text("Assigned to:")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .bold()
                    Text(workerName)
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    if let date = complaint.assignedDate {
                        Text(date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                assignSection
            }

            // 🔹 Mark Resolved
//            if complaint.status != "Resolved" {
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        Firestore.firestore().collection("complaints")
//                            .document(complaint.id)
//                            .updateData(["status": "Resolved"])
//                    }) {
//                        Text("Mark as Resolved")
//                            .bold()
//                            .frame(width: 160)
//                            .padding(.vertical, 8)
//                            .foregroundColor(.white)
//                            .background(
//                                LinearGradient(colors: [.green, .mint],
//                                               startPoint: .leading,
//                                               endPoint: .trailing)
//                            )
//                            .clipShape(RoundedRectangle(cornerRadius: 12))
//                            .shadow(color: .black.opacity(0.15), radius: 6, y: 4)
//                    }
//                   .disabled(!complaint.workerCompleted)
//                    Spacer()
//                }
//                .padding(.top, 6)
//            }
//            
            if complaint.status != "Resolved" {
                       HStack(spacing: 12) {
                           // Assign Worker Button
                      

                           // Mark Resolved Button (disabled until worker completes)
                           Button(action: {
                               markAsResolvedAndPrepareForReward()
                           }) {
                               HStack {
                                  
                                   Text("Mark Resolved").bold()
                               }
//                               .frame(maxWidth: .infinity)
                               .frame(maxWidth: .infinity)
                               .padding()
                               .foregroundColor(.white)
                               .background(
                                   LinearGradient(colors: complaint.workerCompleted ?
                                                  [.green, .mint] : [.gray, .gray],
                                                  startPoint: .leading, endPoint: .trailing)
                               )
                               .cornerRadius(12)
                           }
                           .disabled(!complaint.workerCompleted)
                       }
                       .padding(.top, 8)
                   }


        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
        .padding(.horizontal)
    }

    private var assignSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Assign Worker")
                .font(.subheadline.bold())
                .foregroundColor(.secondary)

            Button(action: { showWorkerSheet = true }) {
                HStack {
                    Image(systemName: "person.crop.circle.badge.plus")
                    Text(selectedWorker?.name ?? "Select Worker")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            }

            DatePicker(
                "Select Date & Time",
                selection: $selectedDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            .labelsHidden()

            Button(action: assignWorker) {
                HStack {
                   
                    Text("Assign Worker").bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(
                    LinearGradient(colors: [.blue, .cyan],
                                   startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(12)
            }
            .disabled(selectedWorker == nil)
        }
        .padding(.top, 6)
    }

    private func assignWorker() {
        guard let worker = selectedWorker else { return }
        vm.assignWorkerAndDate(
            complaintId: complaint.id,
            workerName: worker.name,
            workerId: worker.id,
            date: selectedDate
        )
        selectedWorker = nil
    }
    
    private func markAsResolvedAndPrepareForReward() {
            let db = Firestore.firestore()
            let docRef = db.collection("complaints").document(complaint.id)

            docRef.updateData([
                "status": "Resolved",
                "rewardGiven": false
            ]) { err in
                if let err = err {
                    print("❌ Error updating complaint: \(err.localizedDescription)")
                } else {
                    print("✅ Complaint marked as resolved and ready for reward.")
                }
            }
        }
    
}

// MARK: - Status Badge
struct StatusBadgge: View {
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
        case "Resolved": return (.green, "Resolved")
        case "Assigned": return (.blue, "Assigned")
        case "Pending": return (.orange, "Pending")
        default: return (.gray, status)
        }
    }
}
