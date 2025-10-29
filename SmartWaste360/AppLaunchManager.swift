//
//  AppLaunchManager.swift
//  SmartWaste360
//
//  Created by NIKHIL on 15/10/25.
//

import Foundation
import FirebaseAuth

struct AppLaunchManager {
    static let hasLaunchedKey = "hasLaunchedBefore"

    static func handleFirstLaunch() {
        let defaults = UserDefaults.standard
        
        if !defaults.bool(forKey: hasLaunchedKey) {
            // 🔹 First launch after fresh install
            print("🟡 First launch detected — signing out existing user.")
            
            do {
                try Auth.auth().signOut()
                print("✅ User automatically logged out on first launch.")
            } catch {
                print("❌ Error signing out on first launch: \(error.localizedDescription)")
            }
            
            defaults.set(true, forKey: hasLaunchedKey)
            defaults.synchronize()
        } else {
            print("🔹 Not first launch — keeping existing session.")
        }
    }
}

