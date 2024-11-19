//
//  RewardsGamificationView.swift
//  iCitizen
//
//  Created by BitDegree on 19/11/24.
//

import SwiftUI

struct RewardsGamificationView: View {
    @State private var rewardPoints: Int = 120
    @State private var badges: [String] = ["Active Reporter", "Community Leader"]
    @State private var userRank: Int = 5
    @State private var totalCitizens: Int = 100
    @State private var activityLog: [String] = ["Reported a road issue", "Participated in a local event"]
    @State private var inactivityPenalty: Int = 0
    @State private var showBadgeAnimation = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Title Section
                    VStack {
                        Text("Rewards")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                        Divider()
                    }

                    // Reward Points Section
                    VStack(spacing: 15) {
                        Text("Your Reward Points")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("\(rewardPoints) points")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .scaleEffect(showBadgeAnimation ? 1.2 : 1)
                            .animation(showBadgeAnimation ? .spring(response: 0.5, dampingFraction: 0.6) : .none, value: showBadgeAnimation)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5)

                    // Achievement Badges Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Achievement Badges")
                            .font(.headline)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(badges, id: \.self) { badge in
                                    Text(badge)
                                        .padding(10)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .cornerRadius(15)
                                        .shadow(color: .blue.opacity(0.3), radius: 5)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Ranking Section
                    VStack(spacing: 10) {
                        Text("Your Rank")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("#\(userRank) of \(totalCitizens)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(userRank <= 10 ? .blue : .gray)

                        ProgressView(value: Double(totalCitizens - userRank), total: Double(totalCitizens))
                            .padding(.horizontal)
                            .tint(userRank <= 10 ? .blue : .gray)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5)

                    // Inactivity Penalty Section
                    if inactivityPenalty > 0 {
                        VStack(spacing: 10) {
                            Text("Inactivity Penalty")
                                .font(.headline)
                                .foregroundColor(.red)
                            Text("You lost \(inactivityPenalty) points for inactivity.")
                                .font(.subheadline)
                                .foregroundColor(.red.opacity(0.8))
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(15)
                        .shadow(color: Color.red.opacity(0.2), radius: 5)
                    }

                    // Activity Log Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Activity Log")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(activityLog, id: \.self) { activity in
                            HStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 8, height: 8)
                                Text(activity)
                                    .font(.subheadline)
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Buttons Section
                    VStack(spacing: 15) {
                        Button(action: {
                            reportIssue()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Report an Issue")
                            }
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                            .shadow(color: Color.green.opacity(0.3), radius: 5)
                        }

                        Button(action: {
                            simulateInactivity()
                        }) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                Text("Simulate Inactivity")
                            }
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                            .shadow(color: Color.red.opacity(0.3), radius: 5)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationTitle("Rewards & Gamification")
        }
    }

    // MARK: - Simulate Reporting an Issue
    private func reportIssue() {
        rewardPoints += 10
        activityLog.append("Reported an issue on \(formattedDate())")
        if rewardPoints >= 100 && !badges.contains("Active Reporter") {
            badges.append("Active Reporter")
        }

        // Show badge animation
        withAnimation {
            showBadgeAnimation = true
        }

        // Reset animation after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showBadgeAnimation = false
        }
    }

    // MARK: - Simulate Inactivity Penalty
    private func simulateInactivity() {
        inactivityPenalty += 5
        rewardPoints = max(0, rewardPoints - 5)
        if rewardPoints < 100 {
            badges.removeAll { $0 == "Active Reporter" }
        }
    }

    // MARK: - Helper: Get Current Date
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: Date())
    }
}

struct RewardsGamificationView_Previews: PreviewProvider {
    static var previews: some View {
        RewardsGamificationView()
    }
}
