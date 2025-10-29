//
//  ComplaintFormView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI

struct ComplaintFormView: View {
    @StateObject var vm = ComplaintViewModel()
    @State private var description = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var isSubmitting = false
    @State private var showSuccess = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 🔹 Header
                HStack(spacing: 12) {
                    Text("Report Waste Complaint")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                    
                }
                .padding(.top, 10)
                
                
                // Image Picker
                VStack {
                    if let img = selectedImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                            .onTapGesture { showImagePicker.toggle() }
                    } else {
                        VStack(spacing: 10) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 40))
                                .foregroundColor(.green)
                            Text("Tap to upload photo")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 15))
                        .onTapGesture { showImagePicker.toggle() }
                    }
                }
                .padding(.horizontal, 20)
                
                // 🔹 Card with fields
                VStack(spacing: 20) {
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.subheadline).foregroundColor(.secondary)
                        
                        TextEditor(text: $description)
                            .frame(height: 120)
                            .padding(12)
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                            )
                    }
                    
                 
                }
                .padding(20)
                .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
                .padding(.horizontal)
                
                // 🔹 Submit Button
                Button(action: submitComplaint) {
                    HStack {
                        if isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Submit Complaint").bold()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(colors: [.green, .mint],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: .black.opacity(0.2), radius: 6, y: 4)
                }
                .disabled(isSubmitting || description.isEmpty || selectedImage == nil)
                .padding(.horizontal)
                
                Spacer(minLength: 20)
            }
            .padding(.bottom, 30)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .alert("Complaint Submitted", isPresented: $showSuccess) {
            Button("OK", role: .cancel) {}
        }
    }
    
    // MARK: - Submit Function
    private func submitComplaint() {
        guard let image = selectedImage else { return }
        
        isSubmitting = true
        vm.submitComplaint(description: description, image: image) { success in
            isSubmitting = false
            if success {
                description = ""
                selectedImage = nil
                showSuccess = true
            }
        }
    }
}
