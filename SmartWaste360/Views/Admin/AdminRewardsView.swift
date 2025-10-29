//
//  AdminRewardsView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//




//import SwiftUI
//
//struct AdminRewardsView: View {
//    @StateObject var vm = RewardViewModel()
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 16) {
//                if vm.pendingRewards.isEmpty {
//                    VStack(spacing: 12) {
//                        Image(systemName: "gift.circle.fill")
//                            .font(.system(size: 60))
//                            .foregroundColor(.gray)
//                        Text("No pending rewards yet")
//                            .foregroundColor(.secondary)
//                    }
//                    .padding(.top, 100)
//                } else {
//                    ForEach(vm.pendingRewards) { item in
//                        RewardCard(item: item) {
//                            vm.rewardCitizen(for: item)
//                        }
//                    }
//                }
//            }
//            .padding(.vertical)
//        }
//        .navigationTitle("Manage Rewards")
//        .onAppear { vm.fetchPendingRewards() }
//    }
//}
//
//// MARK: - Premium Reward Card
//struct RewardCard: View {
//    let item: RewardItem
//    var onReward: () -> Void
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            // Header
//            HStack {
//                Text(item.type.uppercased())
//                    .font(.caption.bold())
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 4)
//                    .background(item.type == "pickup" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
//                    .cornerRadius(8)
//
//                Spacer()
//                Text(item.createdAt.formatted(date: .abbreviated, time: .shortened))
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//
////            Text("Description: \(item.description ?? "No details")")
////                .font(.headline)
////                .foregroundColor(.primary)
////            Text("Address: \(item.address)")
////                .foregroundColor(.gray)
////                .font(.subheadline)
//
//            
//            (
//                Text("Description: ")
//                    .font(.headline)
//                    .foregroundColor(.gray)
//                    .bold()
//                +
//                Text(item.description ?? "No details")
//                    .font(.headline)
//                    .foregroundColor(.primary)
//            )
//                
//            (
//                Text("Address: ")
//                    .font(.headline)
//                    .foregroundColor(.gray)
//                    .bold()
//                +
//                Text(item.address)
//                    .font(.subheadline)
//                    .foregroundColor(.black)
//            )
//
//            
//            if let img = item.uiImage {
//                Image(uiImage: img)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(height: 150)
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//                    .shadow(radius: 3)
//            }
//
//            // Button changes visually after reward
//            Button(action: {
//                if item.status != "Rewarded" {
//                    onReward()
//                }
//            }) {
//                HStack {
//                    Image(systemName: item.status == "Rewarded" ? "checkmark.seal.fill" : "gift.fill")
//                    Text(item.status == "Rewarded" ? "Rewarded" : "Reward Citizen (+5 pts)")
//                        .bold()
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//                .foregroundColor(.white)
//                .background(
//                    LinearGradient(
//                        colors: item.status == "Rewarded" ? [.gray, .mint] : [.purple, .pink],
//                        startPoint: .leading,
//                        endPoint: .trailing
//                    )
//                )
//                .clipShape(RoundedRectangle(cornerRadius: 12))
//                .shadow(color: .black.opacity(0.15), radius: 6, y: 4)
//            }
//            .disabled(item.status == "Rewarded")
//        }
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
//        .padding(.horizontal)
//    }
//}

import SwiftUI

struct AdminRewardsView: View {
    @StateObject var vm = RewardViewModel()

    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Segmented Filter Bar
            HStack(spacing: 10) {
                FilterButton(title: "All", count: vm.allCount, selected: vm.filter == .all, color: .blue) {
                    vm.filter = .all
                }
                FilterButton(title: "Pending", count: vm.pendingCount, selected: vm.filter == .pending, color: .orange) {
                    vm.filter = .pending
                }
                FilterButton(title: "Rewarded", count: vm.rewardedCount, selected: vm.filter == .rewarded, color: .green) {
                    vm.filter = .rewarded
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Divider()

            // MARK: - Reward Cards
            ScrollView {
                LazyVStack(spacing: 16) {
                    if vm.filteredRewards.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "gift.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("No \(vm.filter.rawValue.lowercased()) rewards to show")
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 100)
                    } else {
                        ForEach(vm.filteredRewards) { item in
                            RewardCard(item: item) {
                                vm.rewardCitizen(for: item)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Manage Rewards")
        .onAppear { vm.fetchAllRewards() }
    }
}

// MARK: - Filter Button
struct FilterButton: View {
    let title: String
    let count: Int
    let selected: Bool
    let color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .fontWeight(selected ? .bold : .regular)
                Text("(\(count))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(selected ? color.opacity(0.15) : Color(.systemGray6))
            .cornerRadius(10)
            .foregroundColor(selected ? color : .primary)
        }
    }
}

// MARK: - Reward Card
struct RewardCard: View {
    let item: RewardItem
    var onReward: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(item.type.uppercased())
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(item.type == "pickup" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                    .cornerRadius(8)
                Spacer()
                Text(item.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text("Description: \(item.description ?? "No details")")
                .font(.headline)
                .foregroundColor(.primary)
            Text("Address: \(item.address)")
                .foregroundColor(.gray)
                .font(.subheadline)

            if let img = item.uiImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 3)
            }

            Button(action: {
                if !item.rewardGiven {
                    onReward()
                }
            }) {
                HStack {
                    Image(systemName: item.rewardGiven ? "checkmark.seal.fill" : "gift.fill")
                    Text(item.rewardGiven ? "Rewarded " : "Reward Citizen (+5 pts)")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(
                    LinearGradient(
                        colors: item.rewardGiven ? [.gray, .gray] : [.purple, .pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.15), radius: 6, y: 4)
            }
            .disabled(item.rewardGiven)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
        .padding(.horizontal)
    }
}
