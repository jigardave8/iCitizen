//
//  iCitizenApp.swift
//  iCitizen
//
//  Created by BitDegree on 17/11/24.
//

import SwiftUI

@main
struct iCitizenApp: App {
    
    @StateObject private var loginState = LoginState() // Create the LoginState object

    var body: some Scene {
        WindowGroup {
            // Switching views based on login state
            if loginState.isLoggedIn {
                HomePage()
                    .environmentObject(loginState)
            } else {
                LoginPage()
                    .environmentObject(loginState)
            }
        }
    }
}
