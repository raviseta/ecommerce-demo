//
//  WelcomeElement 2.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let title, slug: String
    let price: Double
    let description: String
    let category: CategoryResponse
    let images: [String]
    let creationAt, updatedAt: String
}
