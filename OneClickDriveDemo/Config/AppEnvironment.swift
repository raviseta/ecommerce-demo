//
//  App.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 21/05/25.
//

protocol Configuration {
    var apiUrl: String { get }
}

protocol Development: Configuration {
    var enableDebugLogging: Bool { get }
}

struct DevConfiguration: Development {
    let apiUrl = "https://api.escuelajs.co/api/v1/"
    let enableDebugLogging = true
}

struct ProdConfiguration: Configuration {
    let apiUrl = "https://api.escuelajs.co/api/v1/"
}

class AppEnvironment {
    static let shared = AppEnvironment()
    
    let config: Configuration

    private init() {
        #if DEBUG
        self.config = DevConfiguration()
        #else
        self.config = ProdConfiguration()
        #endif
    }
}
