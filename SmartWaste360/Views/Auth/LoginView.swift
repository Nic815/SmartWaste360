//
//  LoginView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//



//import SwiftUI
//
//struct LoginView: View {
//    @ObservedObject var vm: AuthViewModel
//
//    @State private var email = ""
//    @State private var password = ""
//    @State private var selectedRole = "citizen"  // Default role
//    @State private var showSignup = false
//    @State private var isLoading = false
//
//    private let roles = ["citizen", "worker", "admin"]
//
//    var body: some View {
//        ZStack {
//            Color(.systemBackground) // ✅ use system background (light/dark adaptive)
//
//            VStack(spacing: 22) {
//                Spacer(minLength: 40)   // keep clear of the notch
//
//                // Logo + title
//                VStack(spacing: 10) {
//                    Image(systemName: "leaf.circle.fill")
//                        .resizable()
//                        .frame(width: 88, height: 88)
//                        .foregroundStyle(.green, .white)
//                        .shadow(radius: 8)
//
//                    Text("SmartWaste360")
//                        .font(.largeTitle.bold())
//                        .foregroundColor(.primary)
//                }
//                .padding(.bottom, 6)
//
//                // Frosted card (now just a rounded card)
//                VStack(spacing: 18) {
//                    // Role selector
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Login as")
//                            .font(.subheadline).foregroundColor(.secondary)
//                        Picker("Role", selection: $selectedRole) {
//                            ForEach(roles, id: \.self) { role in
//                                Text(role.capitalized).tag(role)
//                            }
//                        }
//                        .pickerStyle(.segmented)
//                    }
//
//                    // Email
//                    HStack(spacing: 12) {
//                        Image(systemName: "envelope.fill")
//                            .foregroundColor(.green)
//                        TextField("Email", text: $email)
//                            .keyboardType(.emailAddress)
//                            .textInputAutocapitalization(.never)
//                            .autocorrectionDisabled()
//                    }
//                    .padding(14)
//                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
//
//                    // Password
//                    HStack(spacing: 12) {
//                        Image(systemName: "lock.fill")
//                            .foregroundColor(.green)
//                        SecureField("Password", text: $password)
//                    }
//                    .padding(14)
//                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
//
//                    // Login
//                    Button(action: login) {
//                        HStack {
//                            if isLoading {
//                                ProgressView()
//                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                            } else {
//                                Image(systemName: "arrow.right.circle.fill")
//                                Text("Login").bold()
//                            }
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 14)
//                        .foregroundColor(.white)
//                        .background(
//                            LinearGradient(colors: [.green, .mint],
//                                           startPoint: .leading, endPoint: .trailing)
//                        )
//                        .clipShape(RoundedRectangle(cornerRadius: 12))
//                        .shadow(color: .black.opacity(0.15), radius: 6, y: 4)
//                    }
//                    .disabled(email.isEmpty || password.isEmpty || isLoading)
//
//                    // Signup
//                    HStack(spacing: 6) {
//                        Text("Don't have an account?")
//                            .foregroundColor(.secondary)
//                        Button("Sign Up") { showSignup = true }
//                            .foregroundColor(.green).bold()
//                    }
//                    .font(.footnote)
//
//                    // Error
//                    if let error = vm.errorMessage {
//                        Text(error)
//                            .font(.footnote)
//                            .foregroundColor(.red)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.top, 4)
//                    }
//                }
//                .padding(20)
//                .frame(maxWidth: 420)
//                .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 20))
//                .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
//
//                Spacer(minLength: 24)
//            }
//            .padding(.horizontal, 20)
//            .padding(.bottom, 20)
//        }
//        .ignoresSafeArea(.keyboard, edges: .bottom) // ✅ fix sideways jump
//        .sheet(isPresented: $showSignup) {
//            SignupView(vm: vm)
//        }
//        .fullScreenCover(isPresented: $vm.isLoggedIn) {
//            switch selectedRole {
//            case "worker": WorkerDashboardView()
//            case "admin":  AdminDashboardView()
//            default:       CitizenDashboardView()
//            }
//        }
//    }
//
//    // MARK: - Actions
//    private func login() {
//        guard !email.isEmpty, !password.isEmpty, !isLoading else { return }
//        isLoading = true
//        vm.login(email: email, password: password)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
//            isLoading = false
//        }
//    }
//}

import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole = "citizen"  // Default role
    @State private var showSignup = false
    @State private var isLoading = false

    private let roles = ["citizen", "worker", "admin"]

    var body: some View {
        ZStack {
            Color(.systemBackground)

            VStack(spacing: 22) {
                Spacer(minLength: 40)

                // Logo
                VStack(spacing: 10) {
                    Image(systemName: "leaf.circle.fill")
                        .resizable()
                        .frame(width: 88, height: 88)
                        .foregroundStyle(.green, .white)
                        .shadow(radius: 8)
                    Text("SmartWaste360")
                        .font(.largeTitle.bold())
                        .foregroundColor(.primary)
                }
                .padding(.bottom, 6)

                // Login card
                VStack(spacing: 18) {

                    // Role selector
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Login as")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Picker("Role", selection: $selectedRole) {
                            ForEach(roles, id: \.self) { role in
                                Text(role.capitalized).tag(role)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: selectedRole) { newRole in
                            autofillCredentials(for: newRole)
                        }
                    }

                    // Email
                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.green)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    .padding(14)
                    .background(Color(.secondarySystemBackground),
                                in: RoundedRectangle(cornerRadius: 12))

                    // Password
                    HStack(spacing: 12) {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.green)
                        SecureField("Password", text: $password)
                    }
                    .padding(14)
                    .background(Color(.secondarySystemBackground),
                                in: RoundedRectangle(cornerRadius: 12))

                    // Login button
                    Button(action: login) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(
                                        CircularProgressViewStyle(tint: .white)
                                    )
                            } else {
                                Image(systemName: "arrow.right.circle.fill")
                                Text("Login").bold()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(colors: [.green, .mint],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.15), radius: 6, y: 4)
                    }
                    .disabled(email.isEmpty || password.isEmpty || isLoading)

                    // Signup
                    HStack(spacing: 6) {
                        Text("Don't have an account?")
                            .foregroundColor(.secondary)
                        Button("Sign Up") { showSignup = true }
                            .foregroundColor(.green)
                            .bold()
                    }
                    .font(.footnote)

                    // Error message
                    if let error = vm.errorMessage {
                        Text(error)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)
                    }
                }
                .padding(20)
                .frame(maxWidth: 420)
                .background(Color(.systemBackground),
                            in: RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.1), radius: 10, y: 4)

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $showSignup) {
            SignupView(vm: vm)
        }
        .fullScreenCover(isPresented: $vm.isLoggedIn) {
            switch selectedRole {
            case "worker":
                WorkerDashboardView()
            case "admin":
                AdminDashboardView()
            default:
                CitizenDashboardView()
            }
        }
        .onAppear {
            // Auto-fill default role credentials on launch
            autofillCredentials(for: selectedRole)
        }
    }

    // MARK: - Actions

    private func login() {
        guard !email.isEmpty, !password.isEmpty, !isLoading else { return }
        isLoading = true
        vm.login(email: email, password: password)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLoading = false
        }
    }

    // MARK: - Hardcoded Testing Accounts
    private func autofillCredentials(for role: String) {
        switch role {
        case "admin":
            email = "lk16753@gmail.com"
            password = "Nikhil@123"
        case "worker":
            email = "22164@iiitu.ac.in"
            password = "Nikhil@123"
        default:
            email = "22142@iiitu.ac.in"
            password = "Nikhil@123"
        }
    }
}
