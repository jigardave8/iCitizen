//
//  HomePage.swift
//  iCitizen
//
//  Created by BitDegree on 18/11/24.
//

//
//  HomePage.swift
//  iCitizen
//
//  Created by BitDegree on 18/11/24.
//

import SwiftUI

struct HomePage: View {
    @EnvironmentObject var loginState: LoginState
    @State private var isMenuOpen = false

    var body: some View {
        ZStack {
            // Main TabView
            TabView {
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "house.fill")
                    }
                ResearchSurveysView()
                    .tabItem {
                        Label("Research & Earn", systemImage: "sparkle.magnifyingglass")
                    }
                ReportIssueView()
                    .tabItem {
                        Label("Report Issue", systemImage: "exclamationmark.triangle.fill")
                    }
                MLAMonitoringView()
                    .tabItem {
                        Label("MLA Meet", systemImage: "person.bust.circle.fill")
                    }
                MarketplaceView()
                    .tabItem {
                        Label("Trade/Shop", systemImage: "tag.square")
                    }
                TutorialsAndBroadcastsView()
                    .tabItem {
                        Label("Learn/Broadcast", systemImage: "building.columns.circle")
                    }
                RewardsGamificationView()
                    .tabItem {
                        Label("Rewards", systemImage: "bitcoinsign")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                SettingsView(logoutAction: logout)
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            .accentColor(.red) // Customize the tab selection color

            // Floating Action Button
            FloatingActionButton(isMenuOpen: $isMenuOpen)
        }
    }

    private func logout() {
        loginState.isLoggedIn = false
    }
}

// Floating Action Button Component
// Floating Action Button Component
struct FloatingActionButton: View {
    @Binding var isMenuOpen: Bool
    @State private var showMenu = false
    
    // Define menu items
    private let menuItems: [(icon: String, label: String, action: () -> Void)] = [
        ("phone.fill", "Emergency Call", { print("Emergency Call tapped") }),
        ("car.fill", "Book Cab", { print("Book Cab tapped") }),
        ("wrench.and.screwdriver.fill", "Report Issue", { print("Report Issue tapped") })
    ]
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    // Menu Items
                    if isMenuOpen {
                        VStack(spacing: 12) {
                            ForEach(menuItems.indices, id: \.self) { index in
                                MenuButton(
                                    icon: menuItems[index].icon,
                                    label: menuItems[index].label,
                                    action: {
                                        withAnimation {
                                            menuItems[index].action()
                                            isMenuOpen = false
                                        }
                                    }
                                )
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.1)
                                        .combined(with: .opacity)
                                        .combined(with: .move(edge: .trailing)),
                                    removal: .scale(scale: 0.1)
                                        .combined(with: .opacity)
                                ))
                                .animation(
                                    .spring(
                                        response: 0.3,
                                        dampingFraction: 0.7,
                                        blendDuration: 0
                                    ).delay(Double(index) * 0.1),
                                    value: isMenuOpen
                                )
                            }
                        }
                        .padding(.bottom, 85)
                    }
                    
                    // Main FAB
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            isMenuOpen.toggle()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 56, height: 56)
                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(isMenuOpen ? 45 : 0))
                        }
                    }
                    .accessibility(label: Text("Quick Actions Menu"))
                }
                .padding(.trailing, 16)
            }
            .padding(.bottom, 16)
        }
        .background(
            Group {
                if isMenuOpen {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                isMenuOpen = false
                            }
                        }
                        .transition(.opacity)
                }
            }
        )
    }
}

// Improved Menu Button Component
struct MenuButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 24)
                
                Text(label)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(Color.blue)
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
            )
        }
    }
}

// Settings View
struct SettingsView: View {
    let logoutAction: () -> Void

    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Configure app preferences and account settings.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            // Logout Button
            Button(action: {
                logoutAction()
            }) {
                Text("Logout")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
        }
    }
}

// Preview for SwiftUI
struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
            .environmentObject(LoginState())
    }
}
