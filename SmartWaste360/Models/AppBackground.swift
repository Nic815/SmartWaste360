//
//  AppBackground.swift
//  SmartWaste360
//
//  Created by NIKHIL on 10/09/25.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        Image("app_background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}
struct BackgroundContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            AppBackground()
            Color.white.opacity(0.15)
                .ignoresSafeArea()
            content
        }
    }
}


