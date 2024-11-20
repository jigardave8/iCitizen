//
//  LoginView.swift
//  iCitizen
//
//  Created by BitDegree on 17/11/24.
//
// LoginState to track login state
import SwiftUI

class LoginState: ObservableObject {
    @Published var isLoggedIn: Bool = false
}

struct LoginPage: View {
    @EnvironmentObject var loginState: LoginState
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isAnimating: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.green, Color.red]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("iCitizen")
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1 : 0.5)
                    .animation(Animation.easeOut(duration: 1.0).delay(0.3))
                
                Text("Welcome Back!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1 : 0.5)
                    .animation(Animation.easeOut(duration: 1.0).delay(0.5))
                
                TextField("Email", text: $username)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 40)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 50)
                    .animation(Animation.easeOut(duration: 1.0).delay(0.7))
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 40)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 50)
                    .animation(Animation.easeOut(duration: 1.0).delay(0.9))
                
                Button(action: {
                    self.validateInputs()
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                   startPoint: .leading,
                                                   endPoint: .trailing))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 50)
                .animation(Animation.easeOut(duration: 1.0).delay(1.1))
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            self.isAnimating = true
        }
    }
    
    private func validateInputs() {
        if !username.contains("@") {
            alertMessage = "Please enter a valid email address."
            showAlert = true
        } else if password.count < 6 {
            alertMessage = "Password must be at least 6 characters long."
            showAlert = true
        } else {
            loginState.isLoggedIn = true
        }
    }
}


