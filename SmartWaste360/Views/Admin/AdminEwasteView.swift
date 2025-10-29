//
//  AdminEwasteView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

//import SwiftUI
//import FirebaseFirestore
//
//struct AdminEwasteView: View {
//    @StateObject var vm = EwasteViewModel()
//    @State private var selectedWorker = ""
//    @State private var selectedDate = Date()
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 16) {
//                ForEach(vm.ewastes) { e in
//                    VStack(alignment: .leading, spacing: 12) {
//
//                        // Header
//                        HStack {
//                            Text("Item:")
//                                .foregroundColor(.gray)
//                            Text(e.itemName)
//                                .font(.headline)
//                            Spacer()
//                            EwasteStatusBadgeee(status: e.status)
//                        }
//
//                        // Condition
//                        HStack {
//                            Text("Condition:")
//                                .foregroundColor(.gray)
//                            Text(e.isWorking ? "Working" : "Not Working")
//                                .font(.subheadline.bold())
//                        }
//
//                        // Address
//                        HStack {
//                            Text("Address:")
//                                .foregroundColor(.gray)
//                            Text(e.address)
//                                .font(.subheadline)
//                        }
//
//                        // Worker
//                        HStack {
//                            Text("Worker:")
//                                .foregroundColor(.gray)
//                            if let worker = e.assignedWorker, !worker.isEmpty {
//                                Text(worker).font(.subheadline)
//                            } else {
//                                Text("Not yet assigned")
//                                    .foregroundColor(.red)
//                                    .font(.subheadline)
//                            }
//                        }
//
//                        // Date
//                        if let date = e.scheduledDate {
//                            HStack {
//                                Text("Pickup:")
//                                    .foregroundColor(.gray)
//                                Text(date.formatted(date: .abbreviated, time: .shortened))
//                                    .foregroundColor(.secondary)
//                            }
//                        }
//
//                        // Image
//                        if let img = e.uiImage {
//                            Image(uiImage: img)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(height: 180)
//                                .frame(maxWidth: .infinity)
//                                .clipShape(RoundedRectangle(cornerRadius: 12))
//                                .shadow(radius: 4)
//                        }
//
//                        // Assign section
//                        if e.status == "Registered" {
//                            VStack(alignment: .leading, spacing: 12) {
//                                Text("Assign Worker & Schedule")
//                                    .font(.subheadline.bold())
//                                    .foregroundColor(.secondary)
//
//                                TextField("Worker name", text: $selectedWorker)
//                                    .padding(12)
//                                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
//
//                                DatePicker("Select Date & Time",
//                                           selection: $selectedDate,
//                                           displayedComponents: [.date, .hourAndMinute])
//                                    .onChange(of: selectedDate) { newValue in
//                                        let cal = Calendar.current
//                                        let hour = cal.component(.hour, from: newValue)
//                                        let minute = cal.component(.minute, from: newValue)
//                                        if hour < 9 {
//                                            selectedDate = cal.date(bySettingHour: 9, minute: 0, second: 0, of: newValue) ?? newValue
//                                        } else if hour > 17 || (hour == 17 && minute > 0) {
//                                            selectedDate = cal.date(bySettingHour: 17, minute: 0, second: 0, of: newValue) ?? newValue
//                                        }
//                                    }
//
//                                // Equal-sized buttons
//                                HStack(spacing: 12) {
//                                    Button {
//                                        vm.assignWorkerAndDate(ewasteId: e.id,
//                                                               workerName: selectedWorker,
//                                                               date: selectedDate)
//                                        selectedWorker = ""
//                                    } label: {
//                                        Text("Assign Worker")
//                                            .bold()
//                                            .frame(width: 140) // ✅ fixed equal width
//                                            .padding(.vertical, 8)
//                                            .foregroundColor(.white)
//                                            .background(
//                                                LinearGradient(colors: [.blue, .cyan],
//                                                               startPoint: .leading,
//                                                               endPoint: .trailing)
//                                            )
//                                            .clipShape(RoundedRectangle(cornerRadius: 12))
//                                    }
//
//                                    Button {
//                                        Firestore.firestore().collection("ewaste")
//                                            .document(e.id)
//                                            .updateData(["status": "Completed"])
//                                    } label: {
//                                        Text("Mark Complete")
//                                            .bold()
//                                            .frame(width: 140) 
//                                            .padding(.vertical, 8)
//                                            .foregroundColor(.white)
//                                            .background(
//                                                Group {
//                                                    if e.workerCompleted {
//                                                        LinearGradient(colors: [.green, .mint],
//                                                                       startPoint: .leading,
//                                                                       endPoint: .trailing)
//                                                    } else {
//                                                        LinearGradient(colors: [.gray, .gray],
//                                                                       startPoint: .leading,
//                                                                       endPoint: .trailing)
//                                                    }
//                                                }
//                                            )
//                                            .clipShape(RoundedRectangle(cornerRadius: 12))
//                                    }
//                                    .disabled(!e.workerCompleted)
//                                }
//
//                            }
//                            .padding(.top, 8)
//                        }
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
//        .navigationTitle("Manage E-Waste")
//        .onAppear {
//            vm.fetchEwaste()
//        }
//    }
//}
//
//struct EwasteStatusBadgeee: View {
//    let status: String
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
//        case "Completed": return (.green, "Completed")
//        case "Assigned":  return (.blue,  "Assigned")
//        case "Registered":return (.orange,"Registered")
//        default:          return (.gray,  "Pending")
//        }
//    }
//}
import SwiftUI
import FirebaseFirestore

struct AdminEwasteView: View {
    @StateObject var vm = EwasteViewModel()
    @StateObject private var workerListVM = WorkerListViewModel()

    @State private var selectedWorker: Worker? = nil
    @State private var showWorkerSheet = false
    @State private var selectedDate = Date()
    
    

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(vm.ewastes) { e in
                    VStack(alignment: .leading, spacing: 12) {

                        // Header
                        HStack {
                            Text("Item:")
                                .foregroundColor(.gray)
                            Text(e.itemName)
                                .font(.headline)
                            Spacer()
                            EwasteStatusBadgeee(status: e.status)
                        }

                        // Condition
                        HStack {
                            Text("Condition:")
                                .foregroundColor(.gray)
                            Text(e.isWorking ? "Working" : "Not Working")
                                .font(.subheadline.bold())
                        }

                        // Address
                        HStack {
                            Text("Address:")
                                .foregroundColor(.gray)
                            Text(e.address)
                                .font(.subheadline)
                        }

                        // Worker
                        HStack {
                            Text("Worker:")
                                .foregroundColor(.gray)
                            if let worker = e.assignedWorker, !worker.isEmpty {
                                Text(worker).font(.subheadline)
                            } else {
                                Text("Not yet assigned")
                                    .foregroundColor(.red)
                                    .font(.subheadline)
                            }
                        }

                        // Date
                        if let date = e.scheduledDate {
                            HStack {
                                Text("Pickup:")
                                    .foregroundColor(.gray)
                                Text(date.formatted(date: .abbreviated, time: .shortened))
                                    .foregroundColor(.secondary)
                            }
                        }

                        // Image
                        if let img = e.uiImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 4)
                        }

                        // Assign section
                        if e.status == "Registered" {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Assign Worker & Schedule")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.secondary)

                                // 🔹 Worker Selection
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

                                // Date Picker
                                DatePicker("Select Date & Time",
                                           selection: $selectedDate,
                                           displayedComponents: [.date, .hourAndMinute])

                                // Equal-sized buttons
                                HStack(spacing: 12) {
                                    Button {
                                        if let worker = selectedWorker {
                                            vm.assignWorkerAndDate(
                                                ewasteId: e.id,
                                                workerName: worker.name,
                                                workerId: worker.id,
                                                date: selectedDate
                                            )
                                            selectedWorker = nil
                                        }
                                    } label: {
                                        Text("Assign Worker")
                                            .bold()
                                            .frame(width: 140)
                                            .padding(.vertical, 8)
                                            .foregroundColor(.white)
                                            .background(
                                                LinearGradient(colors: [.blue, .cyan],
                                                               startPoint: .leading,
                                                               endPoint: .trailing)
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }

                                    Button {
                                        Firestore.firestore().collection("ewaste")
                                            .document(e.id)
                                            .updateData(["status": "Completed"])
                                    } label: {
                                        Text("Mark Complete")
                                            .bold()
                                            .frame(width: 140)
                                            .padding(.vertical, 8)
                                            .foregroundColor(.white)
                                            .background(
                                                LinearGradient(colors: [.green, .mint],
                                                               startPoint: .leading,
                                                               endPoint: .trailing)
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
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
            }
            .padding(.vertical)
        }
        .navigationTitle("Manage E-Waste")
        .onAppear {
            vm.fetchEwaste()
            workerListVM.fetchAllWorkers()
        }
        .sheet(isPresented: $showWorkerSheet) {
            WorkerSelectionSheet(vm: workerListVM) { worker in
                selectedWorker = worker
                showWorkerSheet = false
            }
        }
    }
}
struct EwasteStatusBadgeee: View {
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
        case "Completed": return (.green, "Completed")
        case "Assigned":  return (.blue,  "Assigned")
        case "Registered":return (.orange,"Registered")
        default:          return (.gray,  "Pending")
        }
    }
}
