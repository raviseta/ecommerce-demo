//
//  LoginView.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 21/05/25.
//


import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var router: AppRouter

    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            
            TextField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)

            Button("Login") {
                Task {
                    await viewModel.login(router: router)
                }
            }
            .disabled(viewModel.isLoading)
        }
        .alert(for: $viewModel.alertToDisplay)
        .padding()
    }
}
