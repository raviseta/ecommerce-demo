import SwiftUI
import AppUtil

struct LoginView: View {
    @State private var viewModel: LoginViewModel = LoginViewModel()
    @EnvironmentObject var router: AppRouter

    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(AppFont.largeTitle.ui)

            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.getAppColor(.grayBackground))
                .cornerRadius(8)
                .foregroundColor(.getAppColor(.primaryTextColor))

            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.getAppColor(.grayBackground))
                .cornerRadius(8)
                .foregroundColor(.getAppColor(.primaryTextColor))

            if viewModel.isLoading {
                ProgressView()
            } else {
                Button {
                    Task {
                        await viewModel.login(router: router)
                    }
                } label: {
                    Text("Login")
                        .font(AppFont.title3.ui)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                        .background(Color.getAppColor(.theme))
                        .foregroundStyle(.white)
                }
            }
        }
        .padding()
        .alert(for: $viewModel.alertToDisplay)
    }
}
