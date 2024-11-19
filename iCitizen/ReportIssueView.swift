//
//  ReportIssueView.swift
//  iCitizen
//
//  Created by BitDegree on 19/11/24.
//

import SwiftUI
import UIKit



struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


// Enum to represent different issue types
enum IssueType: String, CaseIterable {
    case trash = "Trash"
    case electricity = "Electricity"
    case traffic = "Traffic"
    case streetlight = "Streetlight"
    case unsafeDriving = "Unsafe Driving"
}

struct ReportIssueView: View {
    @State private var selectedImage: UIImage? // Holds the selected image
    @State private var isImagePickerPresented = false // Toggles the image picker
    @State private var issueDescription: String = "" // Description of the issue
    @State private var gpsLocation: String = "" // Placeholder for GPS location
    @State private var showAlert = false // Alert for success
    @State private var alertMessage = "" // Alert message
    @State private var selectedIssueType: IssueType = .trash // Default issue type
    @State private var powerOutageType: String = "Blackout" // Default for Electricity issue
    @State private var vehicleNumberPlate: String = "" // Vehicle number plate input for traffic
    @State private var streetlightPoleLocation: String = "" // Location input for streetlight issue
    @State private var vehicleDetails: String = "" // Vehicle details for unsafe driving
    @State private var fitnessCertificate: String = "" // Fitness certificate for unsafe driving

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    Text("Select Issue Type")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top)

                    // Issue Type Picker (Default: Trash)
                    Picker("Select Issue Type", selection: $selectedIssueType) {
                        ForEach(IssueType.allCases, id: \.self) { issue in
                            Text(issue.rawValue)
                                .lineLimit(2) // Ensure text does not wrap
//                                .truncationMode(.) // Truncate text if it's too long
                                .font(.system(size: 14)) // Adjust font size if needed
                        }
                    }
//                    .pickerStyle(SegmentedPickerStyle())
                    .pickerStyle(MenuPickerStyle())
                    .padding(4)


                    // Display Selected Image
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding()
                    } else {
                        Text("No Image Selected")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding()
                    }

                    // Button to Select Image
                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        Text("Select Image")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    // Issue Description Input
                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.headline)
                        TextEditor(text: $issueDescription)
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

                    // Handle different categories of issues

                    if selectedIssueType == .electricity {
                        // Power Outage Type Dropdown
                        VStack(alignment: .leading) {
                            Text("Power Outage Type")
                                .font(.headline)
                            Picker("Select Outage Type", selection: $powerOutageType) {
                                Text("Blackout").tag("Blackout")
                                Text("Fluctuation").tag("Fluctuation")
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                        }
                    }

                    if selectedIssueType == .traffic {
                        // Vehicle Number Plate Input
                        VStack(alignment: .leading) {
                            Text("Vehicle Number Plate")
                                .font(.headline)
                            TextField("Enter Vehicle Number Plate", text: $vehicleNumberPlate)
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

                    if selectedIssueType == .streetlight {
                        // Streetlight Pole Location Input
                        VStack(alignment: .leading) {
                            Text("Streetlight Pole Location")
                                .font(.headline)
                            TextField("Enter Pole Location", text: $streetlightPoleLocation)
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

                    if selectedIssueType == .unsafeDriving {
                        // Vehicle Details Input
                        VStack(alignment: .leading) {
                            Text("Vehicle Details")
                                .font(.headline)
                            TextField("Enter Vehicle Details", text: $vehicleDetails)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
                        }
                        // Fitness Certificate Input
                        VStack(alignment: .leading) {
                            Text("Fitness Certificate")
                                .font(.headline)
                            TextField("Enter Fitness Certificate", text: $fitnessCertificate)
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

                    // Placeholder for GPS Location (Mock)
                    VStack(alignment: .leading) {
                        Text("Location")
                            .font(.headline)
                        Text(gpsLocation.isEmpty ? "Fetching location..." : gpsLocation)
                            .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal)
                            .onAppear {
                                fetchLocation()
                            }
                    }

                    // Submit Button
                    Button(action: {
                        submitIssue()
                    }) {
                        Text("Submit")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Report Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle("Report Issue")
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .onTapGesture {
                UIApplication.shared.endEditing() // Dismiss keyboard when tapping outside
            }
        }
    }

    // Mock location fetching
    private func fetchLocation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            gpsLocation = "Lat: -36.8485, Long: 174.7633" // Replace with actual location fetching logic
        }
    }

    // Mock issue submission
    private func submitIssue() {
        if issueDescription.isEmpty || selectedImage == nil || gpsLocation.isEmpty {
            alertMessage = "Please fill in all the details and select an image."
        } else {
            alertMessage = "Your report has been successfully submitted."
        }
        showAlert = true
    }
}
