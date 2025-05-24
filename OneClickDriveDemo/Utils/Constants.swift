//
//  Constants.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

let applicationName = "OneClickDrive"

enum ErrorMessage: String {
    case invalidURL = "Invalid URL."
    case noInternet = "Internet not Available."
    case invalidResponse = "Invalid Response."
    case requestTimeOut = "Request time out."
    case noError = "No Error."
    case fileNotFound = "Unable to find file."
    case unknownError = "Unknown error."
    case emptyState = "Unable to load. Please check after some time."
}

enum ErrorDomain: String {
    case APIDomain = "API"
}

enum ResponseCode: Int {
    case success = 200
}

enum Images: String {
    case placeHolderImage = "product.placeholder"
}
