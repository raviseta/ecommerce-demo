//
//  LoginViewModel.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 21/05/25.
//

import Foundation
import Combine
import Observation

@Observable
@MainActor
class LoginViewModel {
    var email = "john@mail.com"
    var password = "changeme"
    var isLoading = false
    var errorMessage: String?
    var alertToDisplay: AlertData?

    private func validateInputs() -> String? {
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Email cannot be empty."
        }
        if !isValidEmail(email) {
            return "Please enter a valid email address."
        }
        if password.isEmpty {
            return "Password cannot be empty."
        }
        return nil
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    func login(router: AppRouter) async {
        if let validationError = validateInputs() {
            self.errorMessage = validationError
            self.alertToDisplay = .init(title: applicationName, message: validationError, actions: [.init(title: "OK")])
            return
        }
        
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
            
            await MainActor.run {
                router.showHome()
            }
            
        } catch {
            errorMessage = error.localizedDescription
            self.alertToDisplay = .init(error: error)
        }
    }
    
    private func fetchUserProfile() async {
        do {
            let response: UserProfile = try await APIManager.shared.perform(
                path: .profile,
                method: .get,
                body: EmptyBody(),
                options: nil,
                responseType: UserProfile.self
            )
            
            await MainActor.run {
                UserManager.shared.setUser(response)
            }
            print("response", response)
        }
        catch {
            errorMessage = error.localizedDescription
            self.alertToDisplay = .init(error: error)
        }
    }
}
