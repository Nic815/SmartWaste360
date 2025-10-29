//
//  RolePicker.swift
//  SmartWaste360
//
//  Created by NIKHIL on 10/09/25.
//

import SwiftUI

struct RolePicker: View {
    @Binding var selectedRole: String
    let roles = ["citizen", "worker", "admin"]

    var body: some View {
        HStack(spacing: 12) {
            ForEach(roles, id: \.self) { role in
                Button(action: {
                    withAnimation(.spring()) {
                        selectedRole = role
                    }
                }) {
                    Text(role.capitalized)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            ZStack {
                                if selectedRole == role {
                                    LinearGradient(colors: [.green, .mint],
                                                   startPoint: .leading,
                                                   endPoint: .trailing)
                                        .clipShape(Capsule())
                                        .matchedGeometryEffect(id: "role", in: Namespace().wrappedValue)
                                }
                            }
                        )
                        .foregroundColor(selectedRole == role ? .white : .green)
                        .overlay(
                            Capsule()
                                .stroke(Color.green, lineWidth: 1)
                        )
                }
            }
        }
        .padding(4)
        .background(Color.white.opacity(0.15))
        .clipShape(Capsule())
        .shadow(radius: 3)
    }
}
