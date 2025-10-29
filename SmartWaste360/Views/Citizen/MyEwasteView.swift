//
//  MyEwasteView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 10/09/25.
//

import SwiftUI

struct MyEwasteView: View {
    @StateObject var vm = EwasteViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(vm.ewastes) { e in
                    VStack(alignment: .leading, spacing: 12) {
                        
                        // Title + Status
                        HStack {
                           Text("Item: ")
                                .foregroundColor(.gray)
                            Text(e.itemName)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            EwasteStatusBadgee(status: e.status)
                        }
                        
                        // Condition
                        HStack(spacing: 8) {
                            Text("Condition: ")
                                .foregroundColor(.gray)
                            Text(e.isWorking ? "Working" : "Not Working")
                                .font(.subheadline)
                        }
                        
                        // Address
                        HStack(spacing: 8) {
                            Text("Location: ")
                                .foregroundColor(.gray)
                            Text(e.address)
                                .font(.subheadline)
                        }
                        
                        // Worker
                        if let worker = e.assignedWorker, !worker.isEmpty {
                            HStack(spacing: 8) {
                               Text("Worker: ")
                                    .foregroundColor(.gray)
                                Text("Assigned Worker: \(worker)")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                        } else {
                            HStack(spacing: 8) {
                                Text("Worker: ")
                                    .foregroundColor(.gray)
                                Text("No worker assigned yet")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        // Scheduled Date
                        if let date = e.scheduledDate {
                            HStack(spacing: 8) {
                              Text("Date: ")
                                    .foregroundColor(.gray)
                                Text("Pickup: \(date.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        // Image
                        if let img = e.uiImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 160)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 4)
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
        .navigationTitle("My E-Waste")
        .onAppear {
            vm.fetchEwaste(forUserOnly: true)
        }
    }
}

// 🔹 Reusable badge for E-Waste status
struct EwasteStatusBadgee: View {
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
        case "Registered":
            return (.orange, "Registered")
        default:
            return (.gray, "Pending")
        }
    }
}
