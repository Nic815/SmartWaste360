//
//  MyPickupsView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI

struct MyPickupsView: View {
    @StateObject var vm = PickupViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(vm.pickups) { p in
                    VStack(alignment: .leading, spacing: 12) {
                        
                        // Title
                        HStack {
                           Text("Type: ")
                                .foregroundColor(.gray)
                            Text("\(p.type) Waste Pickup")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            StatusBadge(status: p.status)
                        }
                        
                        // Address
                        HStack(spacing: 8) {
                            Text("Location: ")
                                .foregroundColor(.gray)
                            Text(p.address)
                                .font(.subheadline)
                        }
                        
                        // Description
                        if !p.description.isEmpty {
                            HStack(spacing: 8) {
                               Text("Description: ")
                                    .foregroundColor(.gray)
                                Text(p.description)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        // Worker
                        HStack(spacing: 8) {
                            Text("Worker: ")
                                .foregroundColor(.gray)
                            if let worker = p.assignedWorker, !worker.isEmpty {
                                Text("Assigned Worker: \(worker)")
                                    .font(.subheadline)
                            } else {
                                Text("Assigned Worker: Not yet assigned")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Date
                        if let date = p.scheduledDate {
                            HStack(spacing: 8) {
                               Text("Date: ")
                                    .foregroundColor(.gray)
                                Text("Scheduled: \(date.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
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
        .navigationTitle("My Pickups")
        .onAppear {
            vm.fetchPickups(forUserOnly: true)
        }
    }
}

// 🔹 Reuse the same badge style as MyComplaintsView
struct StatusBadge: View {
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
        case "Completed":
            return (.green, "Completed")
        case "Assigned":
            return (.blue, "Assigned")
        case "In Progress":
            return (.orange, "In Progress")
        default:
            return (.gray, "Scheduled")
        }
    }
}
