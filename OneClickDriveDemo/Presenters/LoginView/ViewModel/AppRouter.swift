//
//  AppRouter.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import Foundation
import SwiftUI

enum AppScreen {
    case login
    case home
}
class AppRouter: ObservableObject {
    @Published var currentScreen: AppScreen 

    init() {
        if AppKeyChainManager.shared.accessToken != nil {
            self.currentScreen = .home
        } else {
            self.currentScreen = .login
        }
    }

    func showHome() {
        currentScreen = .home
    }

    func showLogin() {
        UserManager.shared.clearUser()
        currentScreen = .login
    }
}

struct RootView: View {
    @StateObject var router = AppRouter()

    var body: some View {
        Group {
            switch router.currentScreen {
            case .login:
                LoginView()
                    .environmentObject(router)

            case .home:
                HomeView()
                    .environmentObject(router)
            }
        }
    }
}
