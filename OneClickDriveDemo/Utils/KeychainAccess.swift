//
//  KeychainAccess.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import Foundation
import KeychainAccess

let groupName = "group.onederivedemo.pro"
let sharedUserDefaults : UserDefaults? = UserDefaults.init(suiteName: groupName)

enum KeychainConstants : String {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    
    var id : String {
        let bundleId = "com.app.OneClickDriveDemo"
        return "\(bundleId).\(self.rawValue)"
    }
}

struct KeychainConfiguration {
    private static var _serviceName : String?
    static var serviceName : String {
        get {
            return KeychainConfiguration._serviceName ?? sharedUserDefaults?.string(forKey: "serviceName") ?? "oneclickdemo"
        }
        set {
            _serviceName = newValue
        }
    }
    static let accessGroup: String? = nil
}

class AppKeyChainManager {
    private(set) var keychain = Keychain(service: KeychainConfiguration.serviceName)
    static let shared = AppKeyChainManager()
   
    private init(){
        keychain = keychain.synchronizable(true)
    }
    
    func save(key: KeychainConstants, value:String) {
        keychain[key.id] = value
    }
    func read(key: KeychainConstants) -> String? {
        return keychain[key.id]
    }
    func delete(key: KeychainConstants) {
        keychain[key.id] = nil
    }
    
    func deleteAll() {
        delete(key: .accessToken)
        delete(key: .refreshToken)
    }
}

extension AppKeyChainManager {
    var accessToken: String? {
        read(key: .accessToken)
    }

    var refreshToken: String? {
        read(key: .refreshToken)
    }
}
