//
//  AdminPickupView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

//import SwiftUI
//import Foundation
//import FirebaseFirestore
//import FirebaseAuth
//
//struct AdminPickupView: View {
//    @StateObject var vm = PickupViewModel()
//    @State private var selectedWorker = ""
//    @State private var selectedDate = Date()
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 16) {
//                ForEach(vm.pickups) { p in
//                    PickupCardView(p: p,
//                                   selectedWorker: $selectedWorker,
//                                   selectedDate: $selectedDate,
//                                   vm: vm)
//                }
//            }
//            .padding(.vertical)
//        }
//        .navigationTitle("Manage Pickups")
//        .onAppear {
//            vm.fetchPickups()
//        }
//    }
//}
//
//struct PickupCardView: View {
//    let p: Pickup
//    @Binding var selectedWorker: String
//    @Binding var selectedDate: Date
//    var vm: PickupViewModel
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            // Title + Status
//            HStack {
//                Text("Type: ")
//                    .foregroundColor(.gray)
//                Text("\(p.type) Waste Pickup")
//                    .font(.headline)
//                    .foregroundColor(.primary)
//                Spacer()
//                StatusBadge(status: p.status)
//            }
//
//            // Address
//            HStack(spacing: 8) {
//                Text("Location: ")
//                    .foregroundColor(.gray)
//                Text(p.address)
//                    .font(.subheadline)
//            }
//
//            // Description
//            if !p.description.isEmpty {
//                HStack(spacing: 8) {
//                    Text("Description: ")
//                        .foregroundColor(.gray)
//                    Text(p.description)
//                        .font(.subheadline)
//                        .foregroundColor(.black)
//                }
//            }
//
//            // Worker
//            HStack(spacing: 8) {
//                Text("Worker: ")
//                    .foregroundColor(.gray)
//                if let worker = p.assignedWorker, !worker.isEmpty {
//                    Text("\(worker)")
//                        .font(.subheadline)
//                } else {
//                    Text("Not yet assigned")
//                        .font(.subheadline)
//                        .foregroundColor(.red)
//                }
//            }
//
//            // Scheduled Date
//            if let date = p.scheduledDate {
//                HStack(spacing: 8) {
//                    Image(systemName: "calendar")
//                        .foregroundColor(.purple)
//                    Text("Scheduled: \(date.formatted(date: .abbreviated, time: .shortened))")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//            }
//
//            // Assign Worker & Date
//            if p.status == "Scheduled" {
//                assignSection
//            }
//
//            // Mark Completed
//            if p.status == "Assigned" {
//                completeButton
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(Color(.systemBackground))
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
//        .padding(.horizontal)
//    }
//
//    private var assignSection: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            TextField("Enter worker name", text: $selectedWorker)
//                .padding(12)
//                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
//                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25)))
//
//            DatePicker("Select Date & Time",
//                       selection: $selectedDate,
//                       displayedComponents: [.date, .hourAndMinute])
//                .labelsHidden()
//
//            // 🔹 Centered, smaller button
//            HStack {
//                Spacer()
//                Button(action: {
//                    vm.assignWorkerAndDate(pickupId: p.id,
//                                           workerName: selectedWorker,
//                                           date: selectedDate)
//                    selectedWorker = ""
//                }) {
//                    Text("Assign Worker & Date")
//                        .bold()
//                        .frame(width: 160) 
//                        .padding(.vertical, 8)
//                        .foregroundColor(.white)
//                        .background(
//                            LinearGradient(colors: [.blue, .cyan],
//                                           startPoint: .leading,
//                                           endPoint: .trailing)
//                        )
//                        .clipShape(RoundedRectangle(cornerRadius: 12))
//                        .shadow(color: .black.opacity(0.15), radius: 6, y: 4)
//                }
//                Spacer()
//            }
//            .padding(.top, 6)
//        }
//        .padding(.top, 8)
//    }
//
//    private var completeButton: some View {
//        Button(action: {
//            Firestore.firestore().collection("pickups")
//                .document(p.id)
//                .updateData(["status": "Completed"])
//        }) {
//            HStack {
//                Image(systemName: "checkmark.seal.fill")
//                Text("Mark Completed").bold()
//            }
//            .frame(maxWidth: .infinity)
//            .padding()
//            .foregroundColor(.white)
//            .background(
//                LinearGradient(colors: [.green, .mint],
//                               startPoint: .leading,
//                               endPoint: .trailing)
//            )
//            .clipShape(RoundedRectangle(cornerRadius: 12))
//            .shadow(color: .black.opacity(0.15), radius: 6, y: 4)
//        }
//    }
//}


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AdminPickupView: View {
    @StateObject var vm = PickupViewModel()
    @StateObject private var workerListVM = WorkerListViewModel()

    @State private var selectedWorker: Worker? = nil
    @State private var showWorkerSheet = false
    @State private var selectedDate = Date()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(vm.pickups) { p in
                    PickupCardView(
                        p: p,
                        selectedWorker: $selectedWorker,
                        selectedDate: $selectedDate,
                        vm: vm,
                        showWorkerSheet: $showWorkerSheet
                    )
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Manage Pickups")
        .onAppear {
            vm.fetchPickups()
            workerListVM.fetchAllWorkers()
        }
        // 🔹 Worker Selection Sheet
        .sheet(isPresented: $showWorkerSheet) {
            WorkerSelectionSheet(vm: workerListVM) { worker in
                selectedWorker = worker
                showWorkerSheet = false
            }
        }
    }
}

// MARK: - PickupCardView

struct PickupCardView: View {
    let p: Pickup
    @Binding var selectedWorker: Worker?
    @Binding var selectedDate: Date
    var vm: PickupViewModel
    @Binding var showWorkerSheet: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(p.type) Waste Pickup")
                    .font(.headline)
                Spacer()
                StatusBadge(status: p.status)
            }

            Text("Address: \(p.address)")
                .foregroundColor(.secondary)

            if !p.description.isEmpty {
                Text("Description: \(p.description)")
                    .foregroundColor(.gray)
            }

            if let worker = p.assignedWorker, !worker.isEmpty {
                Text("Worker: \(worker)")
                    .foregroundColor(.primary)
            } else {
                Text("Worker: Not yet assigned")
                    .foregroundColor(.red)
            }

            if let date = p.scheduledDate {
                Text("Pickup: \(date.formatted(date: .abbreviated, time: .shortened))")
                    .foregroundColor(.secondary)
            }

            // 🔹 Assignment Section
            if p.status == "Scheduled" {
                VStack(alignment: .leading, spacing: 10) {
                    Button(action: { showWorkerSheet = true }) {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                            Text(selectedWorker?.name ?? "Select Worker")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }

                    DatePicker("Select Date & Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()

                    HStack {
                        Spacer()
                        Button("Assign Worker & Date") {
                            if let worker = selectedWorker {
                                vm.assignWorkerAndDate(
                                    pickupId: p.id,
                                    workerName: worker.name,
                                    workerId: worker.id,
                                    date: selectedDate
                                )
                                selectedWorker = nil
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        Spacer()
                    }
                }
            }

            // ✅ Mark Completed
            if p.status == "Assigned" {
                Button(action: {
                    Firestore.firestore().collection("pickups")
                        .document(p.id)
                        .updateData(["status": "Completed"])
                }) {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                        Text("Mark Completed").bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
        .padding(.horizontal)
    }
}
