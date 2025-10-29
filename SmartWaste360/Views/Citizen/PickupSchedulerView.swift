//
//  PickupSchedulerView.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import SwiftUI

struct PickupSchedulerView: View {
    @StateObject var vm = PickupViewModel()
    @State private var selectedType = "Wet"
    @State private var address = ""
    @State private var description = ""
    @State private var showSuccess = false
    @State private var isBooking = false
    @StateObject private var locationManager = AppLocationManager()
    @State private var showAddressSheet = false


    let types: [(name: String, icon: String, color: Color)] = [
        ("Wet", "leaf.fill", .green),
        ("Dry", "trash.fill", .blue)
       
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // 🔹 Header
                HStack(spacing: 12) {
                
                    
                    Text("Schedule Waste Pickup")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                }
                .padding(.top, 10)
                
                // 🔹 Pickup Type Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Pickup Type")
                        .font(.subheadline).foregroundColor(.secondary)
                    
                    HStack(spacing: 16) {
                        ForEach(types, id: \.name) { type in
                            VStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(type.color.opacity(0.15))
                                        .frame(width: 60, height: 60)
                                    Image(systemName: type.icon)
                                        .font(.system(size: 28))
                                        .foregroundColor(type.color)
                                }
                                Text(type.name)
                                    .font(.subheadline.bold())
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 100, height: 120)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(selectedType == type.name ? type.color.opacity(0.15) : Color(.systemBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(selectedType == type.name ? type.color : Color.gray.opacity(0.3), lineWidth: 2)
                            )
                            .shadow(color: selectedType == type.name ? type.color.opacity(0.3) : .clear,
                                    radius: 6, y: 4)
                            .onTapGesture { selectedType = type.name }
                        }
                    }
                }
                .padding(.horizontal)
                
                // 🔹 Address Field
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Pickup Address")
//                        .font(.subheadline).foregroundColor(.secondary)
//                    
//                    TextField("Enter your address", text: $address)
//                        .padding(12)
//                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
//                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25)))
//                }
                
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
//                .confirmationDialog(
//                    "Select one",
//                    isPresented: $showAddressChoice,
//                    titleVisibility: .visible
//                ) {
//                    Button {
//                        // ✅ Use full address if available, else fallback to city
//                        address = locationManager.fullAddress.isEmpty
//                            ? locationManager.city
//                            : locationManager.fullAddress
//                    } label: {
//                        Text("Use My Current Location")
//                            .foregroundColor(.orange)     // Customize color here
//                            .font(.headline)
//                    }
//
//                    Button(role: .cancel) {
//                        // Simply dismisses dialog
//                        showAddressChoice = false
//                    } label: {
//                        Text("Enter Manually")
//                            .foregroundColor(.orange)      // Customize color here
//                            .font(.headline)
//                    }
//                }
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

                
                .padding(.horizontal)
                
                // 🔹 Description Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description (optional)")
                        .font(.subheadline).foregroundColor(.secondary)
                    
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .padding(12)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25)))
                }
                .padding(.horizontal)
                
                // 🔹 Book Pickup Button
                Button(action: bookPickup) {
                    HStack {
                        if isBooking {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                           
                            Text("Book Pickup").bold()
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
                .disabled(isBooking || address.isEmpty)
                .padding(.horizontal)
                
                Spacer(minLength: 20)
            }
            .padding(.bottom, 30)
        }
        .alert("Pickup Scheduled", isPresented: $showSuccess) {
            Button("OK", role: .cancel) {}
        }
    }
    
    // MARK: - Book Function
    private func bookPickup() {
        isBooking = true
        print("📦 Booking Pickup → Type: \(selectedType), Address: \(address), Desc: \(description)")
        
        vm.bookPickup(type: selectedType,
                      address: address,
                      description: description) { success in
            isBooking = false
            if success {
                address = ""
                description = ""
                showSuccess = true
            }
        }
    }
}


   
       
