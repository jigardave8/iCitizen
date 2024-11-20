//
//  DashboardView.swift
//  iCitizen
//
//  Created by BitDegree on 19/11/24.
//
//

import SwiftUI
import MapKit

// MARK: - Dashboard View
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
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.red]),
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
                            NavigationLink(destination: DetailView(post: post)) {
                                CitizenPostView(post: post)
                            }
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

// MARK: - Detail View
struct DetailView: View {
    let post: CitizenPost
    
    // State variables
    @State private var isResolved = false
    @State private var isAttendingEvent = false
    @State private var surveyCompleted = false
    @State private var showMap = false
    @State private var showShareSheet = false
    
    // For "Issue" Posts: Add map and location features
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Example location
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Post Title and Author
                Text(post.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                HStack {
                    Text("By \(post.author)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(post.date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // Post Content
                Text(post.content)
                    .font(.body)
                    .padding()
                
                // Based on the post category, show the appropriate content
                switch post.category {
                case "Issue":
                    issueDetailsView
                case "Volunteer":
                    volunteerDetailsView
                case "Help":
                    helpDetailsView
                case "Research":
                    researchDetailsView
                default:
                    Text("No additional details available.")
                        .padding()
                }
                
                // Share Button
                Button(action: {
                    showShareSheet.toggle()
                }) {
                    Text("Share Post")
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                }
                .sheet(isPresented: $showShareSheet) {
                    ActivityViewController(activityItems: [post.title, post.content])
                }
            }
        }
        .navigationBarTitle("Post Details", displayMode: .inline)
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Issue Post Details
    private var issueDetailsView: some View {
        VStack {
            // Urgency Indicator
            Text("URGENT!")
                .font(.title)
                .foregroundColor(.red)
                .padding(.top)
            
            // Map to show location
            if showMap {
                Map(coordinateRegion: $region)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding()
            }
            
            Button("Show Location") {
                showMap.toggle()
            }
            .padding()
            
            // Mark as Resolved Button
            Button(action: {
                isResolved.toggle()
            }) {
                Text(isResolved ? "Issue Resolved" : "Mark as Resolved")
                    .foregroundColor(.white)
                    .padding()
                    .background(isResolved ? Color.green : Color.red)
                    .cornerRadius(8)
            }
            .padding(.vertical)
        }
    }
    
    // MARK: - Volunteer Post Details
    private var volunteerDetailsView: some View {
        VStack {
            // Event Details
            Text("Join us for this exciting event!")
                .font(.title)
                .padding(.top)
            
            Text("Location: Community Park, 10 AM")
                .font(.body)
            
            Text("Please bring your own gardening tools.")
                .font(.body)
            
            // RSVP Button
            Button(action: {
                isAttendingEvent.toggle()
            }) {
                Text(isAttendingEvent ? "You are attending" : "RSVP to Attend")
                    .foregroundColor(.white)
                    .padding()
                    .background(isAttendingEvent ? Color.green : Color.blue)
                    .cornerRadius(8)
            }
            .padding(.vertical)
            
            // Contribution/Donation Option
            Button(action: {
                // Implement donation logic
            }) {
                Text("Donate Materials")
                    .foregroundColor(.blue)
                    .padding()
            }
            
            // Gallery of Past Events
            Text("Past Events Gallery:")
                .font(.headline)
                .padding(.top)
            // Add images of past events (implement as necessary)
        }
    }
    
    // MARK: - Help Post Details
    private var helpDetailsView: some View {
        VStack {
            // Progress Bar for Help
            Text("Help Progress")
                .font(.title)
                .padding(.top)
            
            ProgressView(value: 0.5, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle())
                .padding(.bottom)
            
            // Success Stories
            Text("Success Stories:")
                .font(.headline)
            
            Text("Previous help efforts in the community have resulted in significant improvements!")
                .font(.body)
                .padding(.bottom)
            
            // Pledge Help Button
            Button(action: {
                // Implement pledge help functionality
            }) {
                Text("Pledge to Help")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(8)
            }
            .padding(.vertical)
        }
    }
    
    // MARK: - Research Post Details
    private var researchDetailsView: some View {
        VStack {
            // Survey Participation
            Text("Participate in the Survey!")
                .font(.title)
                .padding(.top)
            
            Button(action: {
                surveyCompleted.toggle()
            }) {
                Text(surveyCompleted ? "Survey Completed" : "Complete the Survey")
                    .foregroundColor(.white)
                    .padding()
                    .background(surveyCompleted ? Color.green : Color.blue)
                    .cornerRadius(8)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - ActivityViewController (for Sharing)
import UIKit
import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
