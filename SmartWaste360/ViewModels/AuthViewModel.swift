//
//  AuthViewModel.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var currentUser: UserModel? = nil
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    @Published var isAdmin: Bool = false
    @Published var isWorker: Bool = false
    @Published var userRole: String = ""


    private let db = Firestore.firestore()

//    init() {
//        // ✅ Restore last session
//        if let user = Auth.auth().currentUser {
//            fetchCurrentUser(for: user.uid)
//            self.isLoggedIn = true
//        }
//    }
    
    init() {
        // ✅ Continuously listen for Firebase auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }

            if let user = user {
                print("✅ Auth state restored for user: \(user.uid)")
                self.isLoggedIn = true
                self.fetchCurrentUser(for: user.uid)
            } else {
                print("🟡 No user signed in — showing login screen")
                self.isLoggedIn = false
                self.currentUser = nil
                self.userRole = ""
            }
        }
    }


    // MARK: - Login
    func login(email: String, password: String) {
        FirebaseAuthService.shared.login(email: email, password: password) { success, error in
            DispatchQueue.main.async {
                if success {
                    if let uid = Auth.auth().currentUser?.uid {
                        self.fetchCurrentUser(for: uid)
                    }
                    self.isLoggedIn = true
                } else {
                    self.errorMessage = error
                }
            }
        }
    }

    // MARK: - Sign Up
//    func signUp(name: String, email: String, password: String, role: String) {
//        FirebaseAuthService.shared.signUp(name: name, email: email, password: password, role: role) { success, error in
//            DispatchQueue.main.async {
//                if success {
//                    if let uid = Auth.auth().currentUser?.uid {
//                        self.fetchCurrentUser(for: uid)
//                    }
//                    self.isLoggedIn = true
//                } else {
//                    self.errorMessage = error
//                }
//            }
//        }
//    }
    
    
    //V2
    func signUp(
        name: String,
        email: String,
        password: String,
        role: String,
        address: String? = nil,
        phone: String? = nil
    ) {
        FirebaseAuthService.shared.signUp(
            name: name,
            email: email,
            password: password,
            role: role,
            address: address,
            phone: phone
        ) { success, error in
            DispatchQueue.main.async {
                if success {
                    if let uid = Auth.auth().currentUser?.uid {
                        self.fetchCurrentUser(for: uid) // Fetch user data (including role)
                    }
                    
                    // Set login and role-based flags
                    self.isLoggedIn = true
                    self.userRole = role.lowercased()
                    self.isAdmin = (role.lowercased() == "admin")
                    self.isWorker = (role.lowercased() == "worker")
                    
                    print("✅ Signup successful for \(role) — navigating to dashboard.")
                } else {
                    self.errorMessage = error
                    self.isLoggedIn = false
                    print("❌ Signup failed: \(error ?? "Unknown error")")
                }
            }
        }
    }

    
   //MARK:- 
    
    func checkIfUserIsLoggedIn() {
        if let user = Auth.auth().currentUser {
            self.isLoggedIn = true
            self.fetchCurrentUser(for: user.uid)
        } else {
            self.isLoggedIn = false
            self.userRole = ""
        }
    }

    
    

    // MARK: - Fetch User
//    private func fetchCurrentUser(for uid: String) {
//        db.collection("users").document(uid).getDocument { snapshot, _ in
//            guard let data = snapshot?.data() else { return }
//            // ✅ Manual decoding using UserModel init(id:data:)
//            self.currentUser = UserModel(id: snapshot!.documentID, data: data)
//        }
//    }
    
    private func fetchCurrentUser(for uid: String) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("❌ Error fetching user: \(error.localizedDescription)")
                return
            }
            guard let data = snapshot?.data() else {
                print("⚠️ No Firestore document found for user: \(uid)")
                return
            }

            self.currentUser = UserModel(id: uid, data: data)
            self.userRole = (data["role"] as? String ?? "").lowercased()
            print("✅ User data loaded: \(self.userRole)")
        }
    }


    // MARK: - Logout
    func logout() {
        FirebaseAuthService.shared.logout()
        DispatchQueue.main.async {
            self.currentUser = nil
            self.isLoggedIn = false
        }
    }
}
