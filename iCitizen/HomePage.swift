//
//  HomePage.swift
//  iCitizen
//
//  Created by BitDegree on 18/11/24.
//

import SwiftUI

struct HomePage: View {
    @EnvironmentObject var loginState: LoginState
    
    // Floating menu state
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
            
            // Floating Menu positioned above the TabView
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    FloatingMenu(isMenuOpen: $isMenuOpen)
                        .padding(.trailing, 16) // Padding from right edge
                        .padding(.bottom, 60) // Positioned above TabBar
                }
            }
        }
    }
    
    private func logout() {
        loginState.isLoggedIn = false
    }
}

// Floating Menu Component
struct FloatingMenu: View {
    @Binding var isMenuOpen: Bool
    
    var body: some View {
        ZStack {
            // Background overlay when menu is open
            if isMenuOpen {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isMenuOpen = false
                        }
                    }
            }
            
            // Floating Button and Menu
            VStack(spacing: 12) {
                if isMenuOpen {
                    FloatingMenuButton(icon: "phone.fill", label: "SOS Call") {
                        openPhoneCall()
                    }
                    FloatingMenuButton(icon: "car.fill", label: "Book Cab") {
                        print("Book Cab pressed")
                    }
                    FloatingMenuButton(icon: "wrench.and.screwdriver.fill", label: "Fix Issue") {
                        print("Fix Issue pressed")
                    }
                }
                
                // Main Floating Button
                Button(action: {
                    withAnimation {
                        isMenuOpen.toggle()
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.red)
                        .rotationEffect(.degrees(isMenuOpen ? 45 : 0))
                        .shadow(color: .gray.opacity(0.5), radius: 8, x: 2, y: 2)
                }
            }
        }
    }
}

// Floating Menu Button Component
struct FloatingMenuButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                Text(label)
                    .font(.body)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.5), radius: 5, x: 2, y: 2)
        }
    }
}

// Utility for opening calls
func openPhoneCall() {
    guard let number = URL(string: "tel://123456789") else { return }
    UIApplication.shared.open(number)
}

// Preview for SwiftUI
struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
            .environmentObject(LoginState())
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

