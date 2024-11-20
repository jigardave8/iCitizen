//
//  DashboardView.swift
//  iCitizen
//
//  Created by BitDegree on 19/11/24.
//
//


import SwiftUI

struct DashboardView: View {
    @State private var userName: String = "User"
    @State private var citizenPosts: [CitizenPost] = [
        CitizenPost(author: "John Doe", title: "Road Repairs Needed", content: "Potholes on Elm Street have caused several accidents. Requesting immediate attention!", category: "Issue", date: "Nov 18, 2024"),
        CitizenPost(author: "Jane Smith", title: "Tree Plantation Drive", content: "We planted 50 trees last weekend! Join us next Sunday for another drive.", category: "Volunteer", date: "Nov 17, 2024"),
        CitizenPost(author: "Alex Patel", title: "Water Line Fixed", content: "Thanks to everyone who helped fix the water line issue in Sector 5. Amazing teamwork!", category: "Help", date: "Nov 16, 2024"),
        CitizenPost(author: "Sara Lee", title: "Local Research Study", content: "Conducting a survey on traffic patterns in the city. Participate to help improve commute times.", category: "Research", date: "Nov 15, 2024")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Banner
                    Text("Welcome, \(userName)!")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                   startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    // Feed Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Citizen Posts")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(citizenPosts) { post in
                            CitizenPostView(post: post)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Dashboard")
        }
    }
}

// Citizen Post Model
struct CitizenPost: Identifiable {
    let id = UUID()
    let author: String
    let title: String
    let content: String
    let category: String
    let date: String
}

// Citizen Post View
struct CitizenPostView: View {
    let post: CitizenPost
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(post.author)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Spacer()
                Text(post.date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(post.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(post.content)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            HStack {
                Text(post.category)
                    .font(.caption)
                    .padding(6)
                    .background(categoryColor(for: post.category))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.vertical, 5)
    }
    
    // Helper Function for Category Colors
    func categoryColor(for category: String) -> Color {
        switch category {
        case "Issue": return .red
        case "Volunteer": return .green
        case "Help": return .orange
        case "Research": return .blue
        default: return .gray
        }
    }
}

// Preview
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
