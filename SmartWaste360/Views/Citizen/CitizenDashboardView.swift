//
//  CitizenDashboardView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI
import CoreLocation

struct CitizenDashboardView: View {
    @EnvironmentObject var vm: AuthViewModel
    @StateObject private var locationManager = AppLocationManager()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // 🏠 Home Tab
//            HomeDashboardView()
            HomeDashboardView(locationManager: locationManager)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            // 👤 Profile Tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(1)
        }
    }
}




import SwiftUI

struct HomeDashboardView: View {
    @EnvironmentObject var vm: AuthViewModel
    @ObservedObject var locationManager: AppLocationManager
    @State private var showLogoutAlert = false
    
   
    init(locationManager: AppLocationManager) {
           self._locationManager = ObservedObject(initialValue: locationManager)
       }
    
    // Dashboard options
    let options: [(icon: String, title: String, color: Color, destination: AnyView)] = [
        ("camera.fill", "Report Complaint", .blue, AnyView(ComplaintFormView())),
        ("truck.box.fill", "Schedule Pickup", .green, AnyView(PickupSchedulerView())),
        ("cube.box.fill", "E-Waste", .orange, AnyView(EwasteTrackerView())),
        ("map.fill", "Find Bins", .purple, AnyView(BinLocatorView()))
    ]

    // 2-column layout
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
                        Text(vm.currentUser?.name ?? "Citizen")
                            .font(.title.bold())
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal)

                    // Grid
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(options, id: \.title) { option in
                            NavigationLink(destination: option.destination) {
                                VStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(option.color.opacity(0.2))
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
            .navigationTitle("Dashboard")
            .toolbar {
                
                // MARK: - Custom title view (Location + Dashboard)
                                ToolbarItem(placement: .principal) {
                                    VStack(spacing: 2) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "mappin.and.ellipse")
                                                .foregroundColor(.green)
                                                .font(.system(size: 18, weight: .bold))
                                            Text(locationManager.city)
                                                //.font(.footnote)
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.orange)
                                                //.bold()
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                        }
                                    }
                                }

                
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


import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm: AuthViewModel
    @State private var showLogoutAlert = false
    @StateObject private var rewardVM = UserRewardViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // 🔹 Profile Card
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
                    
                    // 🔹 Quick Links Section
                    VStack(spacing: 16) {
                        NavigationLink(destination: MyComplaintsView()) {
                            ProfileRow(icon: "doc.plaintext", title: "My Complaints", color: .blue)
                        }
                        NavigationLink(destination: MyPickupsView()) {
                            ProfileRow(icon: "truck.box.fill", title: "My Pickups", color: .green)
                        }
                        NavigationLink(destination: MyEwasteView()) {
                            ProfileRow(icon: "cube.box.fill", title: "My Ewaste", color: .orange)
                        }
                        NavigationLink(destination: RewardsView()) {
                            ProfileRow(icon: "gift.fill", title: "My Rewards", color: .purple)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    HStack(spacing: 6) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 14, weight: .bold))
                                Text("\(rewardVM.points)")
                                    .font(.headline)
                                    .foregroundColor(.green)
                                           }
                                           .padding(.horizontal, 10)
                                           .padding(.vertical, 6)
                                           .background(Color.green.opacity(0.15))
                                           .clipShape(Capsule())
                                           .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
                    
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
            .onAppear {
                rewardVM.fetchPoints()
                       }
           
        }
    }
}

// 🔹 Reusable row view
struct ProfileRow: View {
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

