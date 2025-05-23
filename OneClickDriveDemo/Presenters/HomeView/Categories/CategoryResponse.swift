//
//  WelcomeElement.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import Foundation

// MARK: - CategoryMeta
struct CategoryResponse: Decodable {
    let id: Int
    let name, slug: String
    let image: String
    let creationAt, updatedAt: String
}
