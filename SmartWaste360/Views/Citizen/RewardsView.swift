//
//  RewardsView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RewardsView: View {
    @StateObject private var vm = UserRewardViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        // Empty background, no layout
        Color.clear
            .onAppear {
                vm.fetchPoints()

                // Show popup instantly when view opens
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showRewardPopup()
                }
            }
            // Keep toolbar active to show points indicator
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    RewardIndicatorView(points: vm.points)
                }
            }
    }

    // MARK: - Popup
    private func showRewardPopup() {
        let points = vm.points
        let alert = UIAlertController(
            title: "🎉 Total Reward Points",
            message: "You have \(points) reward points!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            dismiss() // Close after OK
        })

        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController?
            .present(alert, animated: true)
    }
}

// MARK: - Permanent Indicator View
struct RewardIndicatorView: View {
    var points: Int

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.green.opacity(0.15))
                .frame(width: 36, height: 36)

            VStack(spacing: 1) {
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.green)
                Text("\(points)")
                    .font(.caption2.bold())
                    .foregroundColor(.green)
            }
        }
        .accessibilityLabel("Total Points: \(points)")
    }
}
