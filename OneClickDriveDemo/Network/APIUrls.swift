//
//  APIUrls.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 21/05/25.
//

enum APIEndPoints {
    case base
   
    var urlString: String {
        switch self {
        case .base:
            return AppEnvironment.shared.config.apiUrl
        }
    }
}

enum ApiUrls: String {
    case login = "auth/login"
    case profile = "auth/profile"
    case categories = "categories"
    case products = "products"
}
