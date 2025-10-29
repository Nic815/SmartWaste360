//
//  EwasteTrackerView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI

struct EwasteTrackerView: View {
    @StateObject var vm = EwasteViewModel()
    @State private var itemName = ""
    @State private var isWorking = true
    @State private var address = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var showSuccess = false
    @State private var showAddressSheet = false
    @StateObject private var locationManager = AppLocationManager()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // 🔹 Header
                HStack(spacing: 12) {
                 
                    Text("Register E-Waste")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                }
                .padding(.top, 10)
                
                // 🔹 Card with fields
                VStack(spacing: 20) {
                    
                    // Image Upload
                    VStack {
                        if let img = selectedImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(radius: 5)
                                .onTapGesture { showImagePicker = true }
                        } else {
                            VStack(spacing: 10) {
                                Image(systemName: "photo.fill.on.rectangle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.green)
                                Text("Tap to upload image")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 15))
                            .onTapGesture { showImagePicker = true }
                        }
                    }
                    
                    // Item Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Item Name")
                            .font(.subheadline).foregroundColor(.secondary)
                        TextField("e.g., Laptop, TV", text: $itemName)
                            .padding(12)
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25)))
                    }
                    
                    // Condition
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Condition")
                            .font(.subheadline).foregroundColor(.secondary)
                        Picker("Condition", selection: $isWorking) {
                            Text("The item is working").tag(true)
                            Text("The item is not working").tag(false)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // Address
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Pickup Address")
//                            .font(.subheadline).foregroundColor(.secondary)
//                        TextField("Enter your address", text: $address)
//                            .padding(12)
//                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
//                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25)))
//                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Pickup Address")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Enter your address", text: $address, onEditingChanged: { editing in
                            if editing {
                                showAddressSheet = true
                            }
                        })
                        .padding(12)
                        .background(
                            Color(.secondarySystemBackground),
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.25))
                        )
                    }
                    .sheet(isPresented: $showAddressSheet) {
                               VStack(spacing: 24) {
                                   Capsule()
                                       .frame(width: 40, height: 5)
                                       .foregroundColor(.gray.opacity(0.4))
                                       .padding(.top, 8)

                                   Text("Select one")
                                       .font(.headline)
                                       .padding(.top, 12)

                                   Button(action: {
                                       address = locationManager.fullAddress.isEmpty
                                           ? locationManager.city
                                           : locationManager.fullAddress
                                       showAddressSheet = false
                                   }) {
                                       Text("Use My Current Location")
                                           .font(.headline)
                                           .foregroundColor(.orange)
                                           .frame(maxWidth: .infinity)
                                           .padding()
                                           .background(LinearGradient(colors: [.white, .white], startPoint: .leading, endPoint: .trailing))
                                           //.background(Color.clear)
                                           .clipShape(RoundedRectangle(cornerRadius: 12))
                                           .shadow(radius: 4)
                                   }

                                   Button(action: {
                                       showAddressSheet = false
                                   }) {
                                       Text("Enter Manually")
                                           .font(.headline)
                                           .foregroundColor(.orange)
                                           .frame(maxWidth: .infinity)
                                           .padding()
                                           .background(LinearGradient(colors: [.white, .white], startPoint: .leading, endPoint: .trailing))
                                         //.background(Color(.secondarySystemBackground))
                                          // .background(Color.clear)
                                           .clipShape(RoundedRectangle(cornerRadius: 12))
                                   }

                                   Spacer()
                               }
                               .padding()
                               .presentationDetents([.fraction(0.3), .fraction(0.4)])
                               .presentationCornerRadius(20)
                           }

                    
                }
                .padding(20)
                .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
                .padding(.horizontal)
                
                // 🔹 Register Button
                Button(action: registerEwaste) {
                    HStack {
                        Text("Register E-Waste").bold()
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
                .disabled(itemName.isEmpty || address.isEmpty || selectedImage == nil)
                .padding(.horizontal)
                
                Spacer(minLength: 20)
            }
            .padding(.bottom, 30)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .alert("E-Waste Registered", isPresented: $showSuccess) {
            Button("OK", role: .cancel) {}
        }
    }

    // MARK: - Register Function
    private func registerEwaste() {
        vm.registerEwaste(itemName: itemName,
                          isWorking: isWorking,
                          address: address,
                          image: selectedImage) { success in
            if success {
                itemName = ""
                address = ""
                selectedImage = nil
                showSuccess = true
            }
        }
    }
}
