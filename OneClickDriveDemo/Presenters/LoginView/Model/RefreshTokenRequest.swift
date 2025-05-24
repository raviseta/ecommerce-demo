//
//  RefreshTokenRequest.swift
//  OneClickDriveDemo
//
//  Created by Alex Carmack on 23/05/25.
//

import Foundation

struct RefreshTokenRequest: Encodable {
    let refreshToken: String

    private enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}