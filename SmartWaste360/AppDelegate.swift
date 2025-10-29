//
//  AppDelegate.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // ✅ Initialize Firebase
        FirebaseApp.configure()

        // ✅ Initialize Google Maps (replace with your real API key)
        GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
        GMSPlacesClient.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")

        print("✅ Firebase & Google Maps configured")
        
        func addRewardGivenFieldToExistingDocs() {
            let db = Firestore.firestore()

            // For pickups
            db.collection("pickups").getDocuments { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                for doc in docs {
                    if doc.data()["rewardGiven"] == nil {
                        db.collection("pickups").document(doc.documentID).updateData(["rewardGiven": false])
                    }
                }
            }

            // For e-waste
            db.collection("ewaste").getDocuments { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                for doc in docs {
                    if doc.data()["rewardGiven"] == nil {
                        db.collection("ewaste").document(doc.documentID).updateData(["rewardGiven": false])
                    }
                }
            }

            print("✅ rewardGiven field added where missing")
        }
        
        
        
        // 🔹 Handle automatic logout on fresh install
               AppLaunchManager.handleFirstLaunch()
        return true
    }
}
