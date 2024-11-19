//
//  DashboardView.swift
//  iCitizen
//
//  Created by BitDegree on 19/11/24.
//
import SwiftUI
import Charts

struct DashboardView: View {
    @State private var userName: String = "User"
    @State private var chartData: [ChartData] = [
        .init(day: "Mon", value: 30),
        .init(day: "Tue", value: 50),
        .init(day: "Wed", value: 40),
        .init(day: "Thu", value: 70),
        .init(day: "Fri", value: 60)
    ]
    
    var body: some View {
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

                // Analytics Chart
                VStack(alignment: .leading, spacing: 10) {
                    Text("Activity Overview")
                        .font(.headline)
                    
                    Chart {
                        ForEach(chartData) { data in
                            BarMark(x: .value("Day", data.day), y: .value("Value", data.value))
                                .foregroundStyle(.blue.gradient)
                        }
                    }
                    .frame(height: 200)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)

                // Quick Actions
                HStack {
                    QuickActionButton(icon: "star.fill", title: "Favorites")
                    QuickActionButton(icon: "gear", title: "Settings")
                    QuickActionButton(icon: "envelope.fill", title: "Messages")
                }
                .padding(.horizontal)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

// Supporting Models and Views
struct ChartData: Identifiable {
    let id = UUID()
    let day: String
    let value: Double
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .padding()
                .background(Color.blue.opacity(0.2))
                .clipShape(Circle())
                .foregroundColor(.blue)
            
            Text(title)
                .font(.footnote)
        }
        .frame(maxWidth: .infinity)
    }
}

