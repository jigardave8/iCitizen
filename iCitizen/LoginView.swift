//
//  LoginView.swift
//  iCitizen
//
//  Created by BitDegree on 17/11/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var showAnimation: Bool = false
    @State private var isValid: Bool = true

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            .overlay(
                // Gamification design layer
                VStack {
                    Image(systemName: "globe")
                        .font(.system(size: 100))
                        .foregroundColor(.white.opacity(0.8))
                        .shadow(color: .blue, radius: 10, x: 0, y: 0)
                        .rotationEffect(.degrees(showAnimation ? 360 : 0))
                        .animation(Animation.linear(duration: 10).repeatForever(autoreverses: false))
                        .onAppear {
                            showAnimation = true
                        }

                    Spacer()
                }
            )

            VStack(spacing: 20) {
                // App Title
                Text("iCitizen")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .shadow(color: .purple, radius: 5, x: 0, y: 0)

                // Email Text Field
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isValidEmail(email) ? Color.green : Color.red, lineWidth: 2)
                    )

                // Password Secure Field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(password.isEmpty ? Color.red : Color.green, lineWidth: 2)
                    )

                // Login Button
                Button(action: validateInputs) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 10)
                .scaleEffect(showError ? 1.1 : 1)
                .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.5))

                // Error Message
                if showError {
                    Text("Invalid email or password")
                        .foregroundColor(.red)
                        .transition(.opacity)
                        .animation(.easeIn)
                }

                Spacer()

                // Footer with gamification elements
                Text("Earn credits by engaging with the community!")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.top, 10)
            }
            .padding()
        }
    }

    // Validation Logic
    private func validateInputs() {
        isValid = isValidEmail(email) && !password.isEmpty
        showError = !isValid
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
