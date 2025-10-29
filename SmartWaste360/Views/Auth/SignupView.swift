//
//  SignupView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

//import SwiftUI
//
//struct SignupView: View {
//    @ObservedObject var vm: AuthViewModel
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var name = ""
//    @State private var email = ""
//    @State private var password = ""
//    @State private var role = "citizen"
//    @State private var isLoading = false
//    
//    private let roles = ["citizen", "worker", "admin"]
//    
//    var body: some View {
//        ZStack {
//            Color(.systemBackground) // ✅ adaptive background (light/dark)
//            
//            VStack(spacing: 22) {
//                Spacer(minLength: 40)
//                
//                // 🔹 Logo + Title
//                VStack(spacing: 10) {
//                    Image(systemName: "leaf.circle.fill")
//                        .resizable()
//                        .frame(width: 88, height: 88)
//                        .foregroundStyle(.green, .white)
//                        .shadow(radius: 8)
//                    
//                    Text("Create Account")
//                        .font(.largeTitle.bold())
//                        .foregroundColor(.primary)
//                }
//                .padding(.bottom, 6)
//                
//                // 🔹 Card with fields
//                VStack(spacing: 18) {
//                    // Name
//                    HStack(spacing: 12) {
//                        Image(systemName: "person.fill")
//                            .foregroundColor(.green)
//                        TextField("Full Name", text: $name)
//                    }
//                    .padding(14)
//                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
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
//                    // Role Picker
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Register as")
//                            .font(.subheadline).foregroundColor(.secondary)
//                        Picker("Role", selection: $role) {
//                            ForEach(roles, id: \.self) { r in
//                                Text(r.capitalized).tag(r)
//                            }
//                        }
//                        .pickerStyle(.segmented)
//                    }
//                    
//                    // Sign Up Button
//                    Button(action: signUp) {
//                        HStack {
//                            if isLoading {
//                                ProgressView()
//                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                            } else {
//                                Image(systemName: "checkmark.circle.fill")
//                                Text("Sign Up").bold()
//                            }
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 14)
//                        .foregroundColor(.white)
//                        .background(
//                            LinearGradient(colors: [.green, .mint],
//                                           startPoint: .leading,
//                                           endPoint: .trailing)
//                        )
//                        .clipShape(RoundedRectangle(cornerRadius: 12))
//                        .shadow(color: .black.opacity(0.15), radius: 6, y: 4)
//                    }
//                    .disabled(name.isEmpty || email.isEmpty || password.isEmpty || isLoading)
//                    
//                    // Cancel button
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                    .foregroundColor(.secondary)
//                    .padding(.top, 4)
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
//        .ignoresSafeArea(.keyboard, edges: .bottom)
//    }
//    
//    // MARK: - Actions
//    private func signUp() {
//        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else { return }
//        isLoading = true
//        vm.signUp(name: name, email: email, password: password, role: role)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
//            isLoading = false
//            dismiss()
//        }
//    }
//}

import SwiftUI
import UIKit

struct SignupView: View {
    @ObservedObject var vm: AuthViewModel
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var role = "citizen"
    @State private var isLoading = false
    @State private var address = ""
    @State private var phone = ""

    private let roles = ["citizen", "worker", "admin"]

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                Spacer(minLength: 30)

                // 🔹 Logo + Title
                VStack(spacing: 10) {
                    Image(systemName: "leaf.circle.fill")
                        .resizable()
                        .frame(width: 88, height: 88)
                        .foregroundStyle(.green, .white)
                        .shadow(radius: 8)

                    Text("Create Account")
                        .font(.largeTitle.bold())
                        .foregroundColor(.primary)
                }
                .padding(.bottom, 6)

                // 🔹 Card with input fields
                VStack(spacing: 18) {
                    // Name
                    inputField(icon: "person.fill", placeholder: "Full Name", text: $name)

                    // Email
                    inputField(icon: "envelope.fill", placeholder: "Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    // Password
                    secureField(icon: "lock.fill", placeholder: "Password", text: $password)

                    // Role Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Register as")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Picker("Role", selection: $role) {
                            ForEach(roles, id: \.self) { r in
                                Text(r.capitalized).tag(r)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    // Extra Fields for Worker
                    if role == "worker" {
                        inputField(icon: "mappin.and.ellipse", placeholder: "Address", text: $address)
                            .textInputAutocapitalization(.words)
                        inputField(icon: "phone.fill", placeholder: "Phone Number", text: $phone)
                            .keyboardType(.phonePad)
                    }

                    // 🔹 Sign Up Button
                    Button(action: signUp) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Sign Up").bold()
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
                    .disabled(
                        name.isEmpty || email.isEmpty || password.isEmpty ||
                        (role == "worker" && (address.isEmpty || phone.isEmpty)) ||
                        isLoading
                    )

                    // 🔹 Cancel Button
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
                }
                .padding(20)
                .frame(maxWidth: 420)
                .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.1), radius: 10, y: 4)

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onTapGesture {
            hideKeyboard()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    // MARK: - Helper UI Components
    private func inputField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
            TextField(placeholder, text: text)
        }
        .padding(14)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    private func secureField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
            SecureField(placeholder, text: text)
        }
        .padding(14)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Actions
    private func signUp() {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else { return }
        isLoading = true
        vm.signUp(
            name: name,
            email: email,
            password: password,
            role: role,
            address: role == "worker" ? address : nil,
            phone: role == "worker" ? phone : nil
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLoading = false
            dismiss()
        }
    }
}

// MARK: - Keyboard Dismiss Extension
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
