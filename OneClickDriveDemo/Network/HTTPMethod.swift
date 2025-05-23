//
//  HTTPMethod.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 21/05/25.
//


import Foundation

enum RestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    
    var allowsBody: Bool {
        switch self {
        case .post, .put, .patch:
            return true
        default:
            return false
        }
    }
    
    var value: String {
        return self.rawValue
    }
}
