//
//  ProfileView.swift
//  iCitizen
//
//  Created by BitDegree on 19/11/24.
//
import SwiftUI

struct ProfileView: View {
    @State private var userName: String = "User1"
    @State private var userEmail: String = "User1@example.com"
    @State private var showEditProfile: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Profile Picture and Name
            VStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.blue)
                
                Text(userName)
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            // Email
            HStack {
                Text("Email:")
                    .font(.headline)
                Spacer()
                Text(userEmail)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Edit Button
            Button(action: {
                showEditProfile = true
            }) {
                Text("Edit Profile")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(userName: $userName, userEmail: $userEmail)
        }
    }
}

// Edit Profile Modal
struct EditProfileView: View {
    @Binding var userName: String
    @Binding var userEmail: String
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $userName)
                }
                Section(header: Text("Email")) {
                    TextField("Email", text: $userEmail)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(trailing: Button("Save") {
                // Close modal
            })
        }
    }
}

