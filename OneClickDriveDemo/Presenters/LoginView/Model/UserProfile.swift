//
//  UserProfile.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import Foundation

struct UserProfile: Codable {
    let id: Int
    let email: String
    let password: String
    let name: String
    let role: String
    let avatar: String
    let creationAt: String
    let updatedAt: String
}

struct EmptyBody: Encodable {}
