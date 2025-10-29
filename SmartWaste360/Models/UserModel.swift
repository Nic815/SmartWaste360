//
//  UserModel.swift
//  SmartWaste360
//
//  Created by NIKHIL on 08/09/25.
//

import Foundation

struct UserModel: Identifiable {
    var id: String
    var name: String
    var email: String
    var role: String
    var points: Int

    init(id: String, data: [String: Any]) {
        self.id = id
        self.name = data["name"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.role = data["role"] as? String ?? "citizen"
        self.points = data["points"] as? Int ?? 0
    }
}
