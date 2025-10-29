//
//  RootView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 09/09/25.
//

import SwiftUI

struct RootView: View {
    @StateObject var vm = AuthViewModel() // Single shared auth view model

    var body: some View {
        if vm.isLoggedIn {
            // ✅ Show role-based dashboard
            if vm.currentUser?.role == "citizen" {
                CitizenDashboardView()
                    .environmentObject(vm) // pass vm down if needed
            } else if vm.currentUser?.role == "worker" {
                WorkerDashboardView()
                    .environmentObject(vm)
            } else if vm.currentUser?.role == "admin" {
                AdminDashboardView()
                    .environmentObject(vm)
            } else {
                Text("")
            }
        } else {
            // ✅ Show login/signup flow
            LoginView(vm: vm)
        }
    }
}
//import SwiftUI
//
//struct RootView: View {
//    @StateObject var vm = AuthViewModel() // Shared ViewModel for all roles
//
//    var body: some View {
//        Group {
//            if !vm.isLoggedIn {
//                // 🔹 Login/Signup Flow
//                LoginView(vm: vm)
//            } else {
//                // 🔹 Role-based dashboard selection
//                switch vm.userRole {
//                case "citizen":
//                    CitizenDashboardView()
//                        .environmentObject(vm)
//
//                case "worker":
//                    WorkerDashboardView()
//                        .environmentObject(vm)
//
//                case "admin":
//                    AdminDashboardView()
//                        .environmentObject(vm)
//
//                default:
//                    ProgressView("Loading your dashboard...")
//                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
//                }
//            }
//        }
//        .animation(.easeInOut, value: vm.userRole)
//        .onAppear {
//            // Optional: auto-login if Firebase session persists
//            vm.checkIfUserIsLoggedIn()
//        }
//    }
//}
