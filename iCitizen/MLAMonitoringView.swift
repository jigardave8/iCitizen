//
//  MLAMonitoringView.swift
//  iCitizen
//
//  Created by BitDegree on 19/11/24.
//

import SwiftUI

struct MLAMonitoringView: View {
    @State private var selectedTab: String = "Attendance Tracker"
    @State private var events: [String] = ["Event 1 - Present", "Event 2 - Absent"]
    @State private var attendanceRate: Double = 85.0
    @State private var rating: Double = 3.0
    @State private var comments: String = ""
    @State private var metrics: [String: Double] = [
        "Events Attended": 20,
        "Promises Made": 15,
        "Promises Kept": 10
    ]
    @State private var eventName: String = ""
    @State private var attendanceStatus: String = "Present"
    @State private var notes: String = ""
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Tab", selection: $selectedTab) {
                    Text("Attendance Tracker").tag("Attendance Tracker")
                    Text("Participation Record").tag("Participation Record")
                    Text("Attendance Reports").tag("Attendance Reports")
                    Text("Election Dashboard").tag("Election Dashboard")
                    Text("Engagement Rating").tag("Engagement Rating")
                    Text("Campaign Metrics").tag("Campaign Metrics")
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                ScrollView {
                    if selectedTab == "Attendance Tracker" {
                        attendanceTrackerView
                    } else if selectedTab == "Participation Record" {
                        participationRecordView
                    } else if selectedTab == "Attendance Reports" {
                        attendanceReportsView
                    } else if selectedTab == "Election Dashboard" {
                        electionDashboardView
                    } else if selectedTab == "Engagement Rating" {
                        engagementRatingView
                    } else if selectedTab == "Campaign Metrics" {
                        campaignMetricsView
                    }
                }
            }
            .navigationTitle("MLA Monitoring")
        }
    }

    // MARK: - Attendance Tracker
    var attendanceTrackerView: some View {
        VStack(spacing: 20) {
            Text("MLA Attendance Tracker")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            TextField("Event Name", text: $eventName)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)

            Picker("Attendance Status", selection: $attendanceStatus) {
                Text("Present").tag("Present")
                Text("Absent").tag("Absent")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if attendanceStatus == "Absent" {
                VStack(alignment: .leading) {
                    Text("Reason for Absence")
                        .font(.headline)
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                }
            }

            Button(action: {
                saveAttendance()
            }) {
                Text("Save Attendance")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text("Attendance has been saved."), dismissButton: .default(Text("OK")))
        }
    }

    // MARK: - Participation Record
    var participationRecordView: some View {
        VStack {
            Text("Event Participation Record")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            List {
                ForEach(events, id: \.self) { event in
                    Text(event)
                }
            }
        }
    }

    // MARK: - Attendance Reports
    var attendanceReportsView: some View {
        VStack(spacing: 20) {
            Text("Public Attendance Report")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Attendance Rate: \(attendanceRate, specifier: "%.1f")%")
                .font(.largeTitle)
                .foregroundColor(attendanceRate > 75 ? .green : .red)

            List {
                ForEach(events, id: \.self) { event in
                    Text(event)
                }
            }
        }
    }

    // MARK: - Election Dashboard
    var electionDashboardView: some View {
        VStack(spacing: 20) {
            Text("Election Impact Dashboard")
                .font(.title)
                .padding()

            Text("Attendance over Time")
                .font(.headline)

            // Placeholder for a chart
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 200)
                .overlay(Text("Chart Placeholder"))
                .padding()
        }
    }

    // MARK: - Engagement Rating
    var engagementRatingView: some View {
        VStack(spacing: 20) {
            Text("Rate MLA Engagement")
                .font(.title)
                .padding()

            Slider(value: $rating, in: 1...5, step: 1)
                .padding()

            Text("Rating: \(Int(rating)) stars")
                .font(.headline)

            TextEditor(text: $comments)
                .frame(height: 100)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)

            Button(action: {
                submitRating()
            }) {
                Text("Submit Rating")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Campaign Metrics
    var campaignMetricsView: some View {
        VStack(spacing: 20) {
            Text("Campaign Evaluation Metrics")
                .font(.title)
                .padding()

            ForEach(metrics.keys.sorted(), id: \.self) { key in
                HStack {
                    Text(key)
                    Spacer()
                    Text("\(metrics[key]!, specifier: "%.0f")")
                }
                .padding()
            }
        }
        .padding()
    }

    // MARK: - Save Attendance
    private func saveAttendance() {
        // Save logic (e.g., database integration)
        events.append("\(eventName) - \(attendanceStatus)")
        showAlert = true
    }

    // MARK: - Submit Rating
    private func submitRating() {
        // Save logic (e.g., database integration)
        showAlert = true
    }
}

struct MLAMonitoringView_Previews: PreviewProvider {
    static var previews: some View {
        MLAMonitoringView()
    }
}
