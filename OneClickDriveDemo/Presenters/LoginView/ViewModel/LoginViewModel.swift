//
//  LoginViewModel.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 21/05/25.
//


import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = "john@mail.com"
    @Published var password = "changeme"
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var alertToDisplay: AlertData?
    
    func login(router: AppRouter) async {
        isLoading = true
        defer { isLoading = false }
        
        let loginRequest = LoginRequest(email: email, password: password)
        
        do {
            let response: LoginResponse = try await APIManager.shared.perform(
                path: .login,
                method: .post,
                body: loginRequest,
                options: .defaultBase,
                responseType: LoginResponse.self
            )
            
            AppKeyChainManager.shared.save(key: .accessToken, value: response.accessToken)
            AppKeyChainManager.shared.save(key: .refreshToken, value: response.refreshToken)
            await fetchUserProfile()
            
            DispatchQueue.main.async {
                router.showHome()
            }
            
        } catch {
            errorMessage = error.localizedDescription
            self.alertToDisplay = .init(error: error)
            
        }
    }
    
    private func fetchUserProfile() async {
        guard let token = AppKeyChainManager.shared.accessToken else {
            self.errorMessage = "No token found"
            return
        }
        
        let options = RestOptions(
            headers: [
                "Authorization": "Bearer \(token)",
            ],
            apiEndpoint: .base
        )
        do {
            let response: UserProfile = try await APIManager.shared.perform(
                path: .profile,
                method: .get,
                body: EmptyBody(),
                options: options,
                responseType: UserProfile.self
            )
            print("response", response)
        }
        catch {
            errorMessage = error.localizedDescription
            self.alertToDisplay = .init(error: error)
        }
    }
}

