//
//  SmartWaste360App.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI
import Firebase

@main
struct SmartWaste360App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootView()
              //  .withAppBackground()
        }
    }
}



