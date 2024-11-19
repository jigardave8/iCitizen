//
//  TutorialsAndBroadcastsView.swift
//  iCitizen
//
//  Created by BitDegree on 19/11/24.
//

import SwiftUI

struct TutorialsAndBroadcastsView: View {
    @State private var selectedTab = "Tutorials"
    
    var body: some View {
        NavigationView {
            VStack {
                // Tab Selection
                Picker("Select Tab", selection: $selectedTab) {
                    Text("Tutorials").tag("Tutorials")
                    Text("Broadcasts").tag("Broadcasts")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Tab Content
                if selectedTab == "Tutorials" {
                    TutorialsTabView()
                } else {
                    BroadcastsTabView()
                }
            }
            .navigationTitle("Learn & Share")
        }
    }
}

// MARK: - Tutorials Tab
struct TutorialsTabView: View {
    @State private var tutorials = [
        Tutorial(id: UUID(), title: "Learn SwiftUI", description: "A beginner's guide to building iOS apps with SwiftUI."),
        Tutorial(id: UUID(), title: "Photography Basics", description: "Tips and tricks to capture stunning photos."),
    ]
    @State private var isAddingTutorial = false
    
    var body: some View {
        VStack {
            // Add Tutorial Button
            Button(action: {
                isAddingTutorial.toggle()
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                    Text("Upload New Tutorial")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $isAddingTutorial) {
                AddTutorialView(tutorials: $tutorials)
            }
            
            // List of Tutorials
            ScrollView {
                ForEach(tutorials) { tutorial in
                    TutorialCard(tutorial: tutorial)
                }
            }
        }
    }
}

// MARK: - Broadcasts Tab
struct BroadcastsTabView: View {
    @State private var broadcasts = [
        Broadcast(id: UUID(), title: "Environmental Awareness", description: "Live discussion on saving the planet."),
        Broadcast(id: UUID(), title: "AI in Everyday Life", description: "Exploring AI's impact on our daily lives."),
    ]
    @State private var isCreatingBroadcast = false
    
    var body: some View {
        VStack {
            // Add Broadcast Button
            Button(action: {
                isCreatingBroadcast.toggle()
            }) {
                HStack {
                    Image(systemName: "video.badge.plus")
                        .foregroundColor(.blue)
                    Text("Create New Broadcast")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $isCreatingBroadcast) {
                CreateBroadcastView(broadcasts: $broadcasts)
            }
            
            // List of Broadcasts
            ScrollView {
                ForEach(broadcasts) { broadcast in
                    BroadcastCard(broadcast: broadcast)
                }
            }
        }
    }
}

// MARK: - Tutorial Model
struct Tutorial: Identifiable {
    let id: UUID
    let title: String
    let description: String
}

// MARK: - Broadcast Model
struct Broadcast: Identifiable {
    let id: UUID
    let title: String
    let description: String
}

// MARK: - Tutorial Card
struct TutorialCard: View {
    let tutorial: Tutorial
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(tutorial.title)
                .font(.headline)
                .foregroundColor(.blue)
            Text(tutorial.description)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
        .padding(.horizontal)
    }
}

// MARK: - Broadcast Card
struct BroadcastCard: View {
    let broadcast: Broadcast
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(broadcast.title)
                .font(.headline)
                .foregroundColor(.green)
            Text(broadcast.description)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
        .padding(.horizontal)
    }
}

// MARK: - Add Tutorial View
struct AddTutorialView: View {
    @Binding var tutorials: [Tutorial]
    @State private var title = ""
    @State private var description = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Tutorial Title", text: $title)
                TextField("Description", text: $description)
                
                Button(action: {
                    let newTutorial = Tutorial(id: UUID(), title: title, description: description)
                    tutorials.append(newTutorial)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Tutorial")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("New Tutorial")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Create Broadcast View
struct CreateBroadcastView: View {
    @Binding var broadcasts: [Broadcast]
    @State private var title = ""
    @State private var description = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Broadcast Title", text: $title)
                TextField("Description", text: $description)
                
                Button(action: {
                    let newBroadcast = Broadcast(id: UUID(), title: title, description: description)
                    broadcasts.append(newBroadcast)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Create Broadcast")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("New Broadcast")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
