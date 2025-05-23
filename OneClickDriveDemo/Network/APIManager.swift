//
//  APIManager.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 21/05/25.
//

import Foundation

public typealias Parameters = [String: any Any & Sendable]
public typealias HTTPHeaders = [String: String]

struct RestOptions {
    var headers: [String:String]?
    var apiEndpoint:APIEndPoints?
}

final class APIManager: Sendable {
    
    static let shared = APIManager()
    
    // MARK: - Perform Async API Call
    func perform<RequestBody: Encodable, Response: Decodable>(
            endpoint: APIEndPoints = .base,
            path: ApiUrls,
            method: RestMethod,
            queryParams: Parameters = [:],
            body: RequestBody? = nil,
            options: RestOptions? = nil,
            responseType: Response.Type
        ) async throws -> Response {
            
            guard let url = URLBuilder.buildUrl(base: endpoint, path: path, queryParams: queryParams) else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = method.value
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let headers = options?.headers {
                for (key, value) in headers {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            if let body = body, method.allowsBody {
                request.httpBody = try JSONEncoder().encode(body)
            }

            let (data, _) = try await URLSession.shared.data(for: request)

            let decoded = try JSONDecoder().decode(Response.self, from: data)
            return decoded
        }
}

struct URLBuilder {
    static func buildUrl(
        base endpoint: APIEndPoints = .base,
        path: ApiUrls,
        queryParams: Parameters = [:]
    ) -> URL? {
        let baseUrl = endpoint.urlString
        let urlString = baseUrl.hasSuffix("/")
            ? "\(baseUrl)\(path.rawValue)"
            : "\(baseUrl)/\(path.rawValue)"

        guard var components = URLComponents(string: urlString) else { return nil }

        if !queryParams.isEmpty {
            components.queryItems = queryParams.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }

        return components.url
    }
}

extension RestOptions {
    static var defaultBase: RestOptions {
        RestOptions(
            headers: [
                "Content-Type": "application/json"
            ],
            apiEndpoint: .base
        )
    }
}
