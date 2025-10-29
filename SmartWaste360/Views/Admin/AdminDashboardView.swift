//
//  AdminDashboardView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI

struct AdminDashboardView: View {
    var body: some View {
        AdminHomeDashboardView()
    }
}

struct AdminHomeDashboardView: View {
    @EnvironmentObject var vm: AuthViewModel
    @State private var showLogoutAlert = false
    @State private var showProfilePopup = false

    // Admin-specific options with unique accent colors
    let options: [(icon: String, title: String, color: Color, destination: AnyView)] = [
        ("exclamationmark.bubble.fill", "Manage Complaints", .red, AnyView(AdminComplaintsView())),
        ("truck.box.fill", "Manage Pickups", .blue, AnyView(AdminPickupView())),
        ("cube.box.fill", "Manage E-Waste", .orange, AnyView(AdminEwasteView())),
        ("gift.fill", "Manage Rewards", .purple, AnyView(AdminRewardsView()))
       
    ]

    let columns = [GridItem(.flexible(), spacing: 20),
                   GridItem(.flexible(), spacing: 20)]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome Back,")
                            .font(.subheadline).foregroundColor(.secondary)
                        Text(vm.currentUser?.name ?? "Admin")
                            .font(.title.bold())
                            .foregroundColor(.primary)
                       
                    }
                    .padding(.horizontal)
                    
                    // Options grid
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(options, id: \.title) { option in
                            NavigationLink(destination: option.destination) {
                                VStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(option.color.opacity(0.15))
                                            .frame(width: 70, height: 70)
                                        Image(systemName: option.icon)
                                            .font(.system(size: 28, weight: .semibold))
                                            .foregroundColor(option.color)
                                    }
                                    Text(option.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(height: 160)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemBackground))
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.08), radius: 6, y: 4)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("Dashboard")
            .toolbar {
                // Profile button (left)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showProfilePopup = true }) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.green)
                    }
                }
                // Logout button (right)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showLogoutAlert = true }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
            // Profile popup sheet
            .sheet(isPresented: $showProfilePopup) {
                VStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .foregroundColor(.green)
                        .shadow(radius: 5)
                    
                    if let user = vm.currentUser {
                        Text(user.name)
                            .font(.title2.bold())
                        Text(user.email)
                            .foregroundColor(.gray)
                        Text("Role: \(user.role.capitalized)")
                            .foregroundColor(.secondary)
                    } else {
                        Text("No user info available")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: { showProfilePopup = false }) {
                        Text("Close")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.top, 10)
                    }
                }
                .padding()
                .frame(maxWidth: 320)
                .presentationDetents([.fraction(0.4)])
            }
            // Logout alert
            .alert("Log Out", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Log Out", role: .destructive) {
                    vm.logout()
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
    }
}
