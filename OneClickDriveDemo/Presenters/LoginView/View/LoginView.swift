import SwiftUI

struct LoginView: View {
    @State private var viewModel: LoginViewModel = LoginViewModel()
    @EnvironmentObject var router: AppRouter

    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            if viewModel.isLoading {
                ProgressView()
            } else {
                Button(action: {
                    Task {
                        await viewModel.login(router: router)
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .alert(for: $viewModel.alertToDisplay)
        .padding()
    }
}
