//
//  UserManager.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 25/05/25.
//

import Foundation
import Observation

@Observable
final class UserManager {
    static let shared = UserManager()
    
    var currentUser: UserProfile? {
        didSet {
            if let user = currentUser {
                saveUserToStorage(user)
            } else {
                clearUserFromStorage()
            }
        }
    }
    
    var userName: String {
        return currentUser?.name ?? "User"
    }
    
    private let userDefaultsKey = "SavedUserProfile"
    
    private init() {
        loadUserFromStorage()
    }
    
    func setUser(_ user: UserProfile) {
        currentUser = user
    }
    
    func clearUser() {
        currentUser = nil
    }
    
    private func saveUserToStorage(_ user: UserProfile) {
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to save user profile: \(error)")
        }
    }
    
    private func loadUserFromStorage() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        
        do {
            let user = try JSONDecoder().decode(UserProfile.self, from: data)
            currentUser = user
        } catch {
            print("Failed to load user profile: \(error)")
        }
    }
    
    private func clearUserFromStorage() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
