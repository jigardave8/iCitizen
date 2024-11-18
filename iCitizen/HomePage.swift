//
//  HomePage.swift
//  iCitizen
//
//  Created by BitDegree on 18/11/24.
//

import SwiftUI

struct HomePage: View {
    @EnvironmentObject var loginState: LoginState

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
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
        .accentColor(.purple) // Customize the tab selection color
    }

    private func logout() {
        loginState.isLoggedIn = false
    }
}

// Dashboard View
struct DashboardView: View {
    var body: some View {
        VStack {
            Text("Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Welcome to the Dashboard! Explore your data and insights here.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
    }
}

// Profile View
struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Manage your account details and personal information.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
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
