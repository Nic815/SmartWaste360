//
//  MyComplaintsView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI

struct MyComplaintsView: View {
    @StateObject var vm = ComplaintViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(vm.complaints) { c in
                    VStack(alignment: .leading, spacing: 12) {
                        
                        // Image if available
                        if let img = c.uiImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 160)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 4)
                        }
                        
                        
                        // Complaint Description
                        Text(c.description)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        // Status + Escalation
                        HStack {
                            StatusBadgee(status: c.status)
                            Spacer()
                            if c.escalationLevel > 0 {
                            EscalationBadge(level: c.escalationLevel)
                                                }
                                            }

                        
                   
                        
                        // Created date
                        Text("Filed on \(c.createdAt.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
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
        .navigationTitle("My Complaints")
        .onAppear {
            vm.fetchComplaints(forUserOnly: true)
        }
    }
}

// 🔹 Reusable badge for status
struct StatusBadgee: View {
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
        case "Resolved":
            return (.green, "Resolved")
        case "In Progress":
            return (.orange, "In Progress")
        default:
            return (.blue, "Submitted")
        }
    }
}
struct EscalationBadge: View {
    let level: Int

    var body: some View {
        let (label, color) = escalationStyle(for: level)

        return HStack(spacing: 6) {
            Image(systemName: "exclamationmark.triangle.fill")
            Text(label)
                .font(.caption.bold())
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.15))
        .foregroundColor(color)
        .cornerRadius(8)
    }

    private func escalationStyle(for level: Int) -> (String, Color) {
        switch level {
        case 1: return ("Escalated to Admin", .orange)
        case 2: return ("Escalated to Manager", .red)
        case 3: return ("Escalated to Supervisor", .purple)
        default: return ("", .gray)
        }
    }
}
