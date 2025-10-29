//
//  WorkerSelectionSheet.swift
//  SmartWaste360
//
//  Created by NIKHIL on 15/10/25.
//

//import SwiftUI
//
//struct WorkerSelectionSheet: View {
//    @ObservedObject var vm: WorkerListViewModel
//    var onSelect: (Worker) -> Void
//
//    var body: some View {
//        VStack(spacing: 16) {
//            Text("Select a Worker")
//                .font(.headline)
//                .padding(.top)
//
//            if vm.workers.isEmpty {
//                ProgressView("Loading...")
//                    .onAppear { vm.fetchAllWorkers() }
//            } else {
//                ScrollView {
//                    ForEach(vm.workers) { worker in
//                        Button {
//                            onSelect(worker)
//                        } label: {
//                            VStack(alignment: .leading, spacing: 8) {
//                                HStack {
//                                    Text(worker.name)
//                                        .font(.headline)
//                                    Spacer()
//                                    Text(worker.status!)
//                                        .font(.caption)
//                                        .foregroundColor(worker.status == "Available" ? .green : .orange)
//                                }
//                                Text("📞 \(worker.phone)")
//                                    .foregroundColor(.gray)
//                                Text("🏠 \(worker.address)")
//                                    .font(.footnote)
//                                    .foregroundColor(.secondary)
//                            }
//                            .padding()
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .background(Color(.systemGray6))
//                            .cornerRadius(10)
//                            .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
//                        }
//                        .padding(.horizontal)
//                    }
//                }
//                .frame(maxHeight: 400)
//            }
//        }
//        .padding()
//    }
//}

import SwiftUI

struct WorkerSelectionSheet: View {
    @ObservedObject var vm: WorkerListViewModel
    var onSelect: (Worker) -> Void

    var body: some View {
        ZStack {
            // 🌿 Soft gradient background
            LinearGradient(colors: [.mint.opacity(0.1), .green.opacity(0.05)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Header
                VStack(spacing: 4) {
                    Text("Select a Worker")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                    Text("Tap a worker card to assign")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)

                // Loading state
                if vm.workers.isEmpty {
                    ProgressView("Loading workers...")
                        .font(.headline)
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .onAppear { vm.fetchAllWorkers() }
                        .padding(.top, 40)
                } else {
                    // Worker List
                    ScrollView {
                        LazyVStack(spacing: 18) {
                            ForEach(vm.workers) { worker in
                                WorkerCardView(worker: worker) {
                                    onSelect(worker)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

struct WorkerCardView: View {
    let worker: Worker
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 10) {
                // Header row
                HStack(alignment: .top) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.green)
                        .shadow(radius: 3)
                        .padding(.trailing, 8)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(worker.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(worker.status ?? "Unknown")
                                .font(.caption.bold())
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(worker.status == "Available" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                                .foregroundColor(worker.status == "Available" ? .green : .orange)
                                .cornerRadius(6)
                        }

                        if let email = worker.email {
                            HStack {
                                Text("Email:")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.gray)
                                Text(email)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                        }

                        Divider().padding(.vertical, 4)

                        // Contact info
//                        VStack(alignment: .leading, spacing: 4) {
//                            Label(worker.phone!, systemImage: "phone.fill")
//                                .font(.subheadline)
//                                .foregroundColor(.secondary)
//                            Label(worker.address!, systemImage: "mappin.and.ellipse")
//                                .font(.subheadline)
//                                .foregroundColor(.secondary)
//                        }
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Phone:")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.gray)
                                Text(worker.phone ?? "N/A")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }

                            HStack {
                                Text("Address:")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.gray)
                                Text(worker.address ?? "N/A")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                        }

                    }
                }

                // Select Button
                HStack {
                    Spacer()
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Select Worker")
                            .bold()
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(colors: [.green, .mint],
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                    Spacer()
                }
                .padding(.top, 6)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
