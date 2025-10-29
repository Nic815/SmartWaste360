//
//  WorkerDashboardView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI

struct WorkerDashboardView: View {
    @EnvironmentObject var vm: AuthViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // 🏠 Home Tab
            WorkerHomeDashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            // 👤 Profile Tab
            WorkerProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(1)
        }
    }
}

struct WorkerHomeDashboardView: View {
    @EnvironmentObject var vm: AuthViewModel
    @State private var showLogoutAlert = false

    // Worker dashboard options
    let options: [(icon: String, title: String, color: Color, destination: AnyView)] = [
        ("truck.box.fill", "Assigned Pickups", .green, AnyView(WorkerPickupView())),
        ("cube.box.fill", "Assigned E-Waste", .orange, AnyView(WorkerEwasteView()))
    ]

    // Grid layout (2-column)
    let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome Back,")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(vm.currentUser?.name ?? "Worker")
                            .font(.title.bold())
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal)

                    // Dashboard grid
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(options, id: \.title) { option in
                            NavigationLink(destination: option.destination) {
                                VStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(option.color.opacity(0.15))
                                            .frame(width: 70, height: 70)
                                        Image(systemName: option.icon)
                                            .font(.system(size: 30, weight: .semibold))
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
                                .shadow(color: .black.opacity(0.1), radius: 6, x: 2, y: 4)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Worker Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showLogoutAlert = true }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
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

struct WorkerProfileView: View {
    @EnvironmentObject var vm: AuthViewModel
    @State private var showLogoutAlert = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    // Profile Card
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                            .shadow(radius: 6)

                        if let user = vm.currentUser {
                            VStack(spacing: 6) {
                                Text(user.name)
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                Text(user.email)
                                    .foregroundColor(.white.opacity(0.85))
                                Text(user.role.capitalized)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .background(
                        LinearGradient(colors: [.green, .mint],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                    .padding(.horizontal)

                    // Quick Links
                    VStack(spacing: 16) {
                        NavigationLink(destination: WorkerPickupView()) {
                            ProfileRow(icon: "truck.box.fill", title: "My Pickups", color: .green)
                        }
                        NavigationLink(destination: WorkerEwasteView()) {
                            ProfileRow(icon: "cube.box.fill", title: "My E-Waste", color: .orange)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showLogoutAlert = true }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
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

// Reusable row component (same as in Citizen)
struct ProfileeRow: View {
    var icon: String
    var title: String
    var color: Color

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .foregroundColor(color)
            }
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
    }
}
