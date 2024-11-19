//
//  ResearchSurveysView.swift
//  iCitizen
//
//  Created by BitDegree on 19/11/24.
//

import SwiftUI

struct ResearchSurveysView: View {
    @State private var surveys = [
        Survey(title: "Road Safety Survey", description: "Share your views on improving road safety in your area.", rewardPoints: 50, isCompleted: false, genre: .general),
        Survey(title: "Electricity Usage Survey", description: "Help us understand energy consumption patterns.", rewardPoints: 30, isCompleted: false, genre: .general),
        Survey(title: "Public Transport Feedback", description: "Provide feedback on the current public transport system.", rewardPoints: 40, isCompleted: false, genre: .general),
        
        // Medical Surveys
        Survey(title: "Health Awareness Survey", description: "Share your opinion on public health policies.", rewardPoints: 70, isCompleted: false, genre: .medical),
        Survey(title: "COVID-19 Vaccine Feedback", description: "Your feedback on vaccination experiences.", rewardPoints: 80, isCompleted: false, genre: .medical),
        
        // Scientific Surveys
        Survey(title: "Climate Change Awareness", description: "How aware are you of climate change?", rewardPoints: 60, isCompleted: false, genre: .scientific),
        Survey(title: "Technology in Education Survey", description: "Feedback on the use of tech in education.", rewardPoints: 65, isCompleted: false, genre: .scientific),
        
        // Technological Surveys
        Survey(title: "AI Usage Feedback", description: "How do you feel about AI in everyday life?", rewardPoints: 90, isCompleted: false, genre: .technological),
        Survey(title: "Smartphone Usage Survey", description: "How often do you use smartphones for work?", rewardPoints: 50, isCompleted: false, genre: .technological)
    ]
    
    @State private var totalPointsEarned = 0
    @State private var showCompletionMessage = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Title Section
                    VStack {
                        Text("Research & Surveys")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                        Divider()
                    }
                    
                    // Points Summary
                    VStack {
                        Text("Total Points Earned")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("\(totalPointsEarned) points")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.bottom, 10)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5)
                    
                    // Surveys List
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Available Surveys")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(surveys.indices, id: \.self) { index in
                            SurveyCard(survey: $surveys[index]) {
                                completeSurvey(index: index)
                            }
                        }
                    }
                    
                    // Job Opportunities Section
                    VStack {
                        Text("Job Opportunities")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.top, 20)
                        
                        JobOpportunityCard(jobTitle: "Freelance High Paid Jobs", description: "Find high-paying freelance opportunities.", rewardPoints: 100)
                        JobOpportunityCard(jobTitle: "Volunteer Jobs", description: "Make a difference with your skills!", rewardPoints: 50)
                        JobOpportunityCard(jobTitle: "Food Testing Jobs", description: "Get paid to test food products.", rewardPoints: 40)
                        JobOpportunityCard(jobTitle: "Scientific Research Testing", description: "Help conduct scientific research for compensation.", rewardPoints: 80)
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("Surveys & Jobs")
            .alert(isPresented: $showCompletionMessage) {
                Alert(title: Text("Survey Completed"), message: Text("Thank you for participating! Your reward points have been added."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // MARK: - Complete Survey
    private func completeSurvey(index: Int) {
        if !surveys[index].isCompleted {
            surveys[index].isCompleted = true
            totalPointsEarned += surveys[index].rewardPoints
            showCompletionMessage = true
        }
    }
}

// MARK: - Survey Model
enum Genre {
    case general, medical, scientific, technological
}

struct Survey {
    let title: String
    let description: String
    let rewardPoints: Int
    var isCompleted: Bool
    var genre: Genre
}

// MARK: - Survey Card View
struct SurveyCard: View {
    @Binding var survey: Survey
    var onComplete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(survey.title)
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                if survey.isCompleted {
                    Text("Completed")
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .padding(6)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                } else {
                    Text("\(survey.rewardPoints) points")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(6)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            Text(survey.description)
                .font(.subheadline)
                .foregroundColor(.primary)
                .padding(.bottom, 10)
            
            if !survey.isCompleted {
                Button(action: {
                    onComplete()
                }) {
                    Text("Participate")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .shadow(color: Color.green.opacity(0.3), radius: 5)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
        .padding(.horizontal)
    }
}

// MARK: - Job Opportunity Card View
struct JobOpportunityCard: View {
    let jobTitle: String
    let description: String
    let rewardPoints: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(jobTitle)
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Text("\(rewardPoints) points")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding(6)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.primary)
                .padding(.bottom, 10)
            
            Button(action: {
                // Add action for job application or details
            }) {
                Text("Apply Now")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
        .padding(.horizontal)
    }
}
