//
//  FirebaseAuthService.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthService {
    static let shared = FirebaseAuthService()
    private let db = Firestore.firestore()

    // MARK: - Sign Up
//    func signUp(name: String,
//                email: String,
//                password: String,
//                role: String,
//                completion: @escaping (Bool, String?) -> Void) {
//
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            if let error = error {
//                completion(false, error.localizedDescription)
//                return
//            }
//
//            guard let uid = result?.user.uid else {
//                completion(false, "No UID found")
//                return
//            }
//
//            // New user document in Firestore
//            let newUser: [String: Any] = [
//                "id": uid,
//                "name": name,
//                "email": email,
//                "role": role,
//                "points": 0
//            ]
//
//            self.db.collection("users").document(uid).setData(newUser) { err in
//                if let err = err {
//                    completion(false, err.localizedDescription)
//                } else {
//                    completion(true, nil)
//                }
//            }
//        }
//    }

    
    //MARK:- signup v2
    func signUp(
        name: String,
        email: String,
        password: String,
        role: String,
        address: String? = nil,
        phone: String? = nil,
        completion: @escaping (Bool, String?) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }

            guard let uid = result?.user.uid else {
                completion(false, "No UID found")
                return
            }

            let db = Firestore.firestore()
            let createdAt = Timestamp(date: Date())

            // 🔹 Base user info (common for all roles)
            var newUser: [String: Any] = [
                "id": uid,
                "name": name,
                "email": email,
                "role": role.lowercased(),
                "createdAt": createdAt
            ]

            // 🔹 Add extra worker-specific fields
            if role.lowercased() == "worker" {
                newUser["address"] = address ?? ""
                newUser["phone"] = phone ?? ""
                newUser["status"] = "Available"
                newUser["assignedPickupId"] = ""
            } else {
                newUser["points"] = 0
            }

            // ✅ 1️⃣ Always save in "users" collection (for role-based dashboard)
            db.collection("users").document(uid).setData(newUser) { err in
                if let err = err {
                    completion(false, err.localizedDescription)
                    return
                }

                // ✅ 2️⃣ If the role is worker, also duplicate entry in "workers"
                if role.lowercased() == "worker" {
                    db.collection("workers").document(uid).setData(newUser) { err2 in
                        if let err2 = err2 {
                            completion(false, err2.localizedDescription)
                        } else {
                            completion(true, nil)
                        }
                    }
                } else {
                    completion(true, nil)
                }
            }
        }
    }


    
    
    // MARK: - Login
    func login(email: String,
               password: String,
               completion: @escaping (Bool, String?) -> Void) {

        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }

    // MARK: - Logout
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("❌ Logout failed: \(error.localizedDescription)")
        }
    }
}
