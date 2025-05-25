import SwiftUI
import AppUtil

struct LoginView: View {
    @State private var viewModel: LoginViewModel = LoginViewModel()
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    LoginHeader(
                        title: "OneClickDrive",
                        subtitle: "Welcome back! Please sign in to continue",
                        systemImage: "cart.fill"
                    )
                    .padding(.bottom, 50)
                    
                    VStack(spacing: 20) {
                        LoginTextField(
                            title: "Email",
                            placeholder: "Enter your email",
                            systemImage: "envelope",
                            text: $viewModel.email,
                            keyboardType: .emailAddress
                        )
                        
                        LoginTextField(
                            title: "Password",
                            placeholder: "Enter your password",
                            systemImage: "lock",
                            text: $viewModel.password,
                            isSecure: true
                        )
                        
                        LoginButton(
                            title: "Sign In",
                            loadingTitle: "Signing In...",
                            isLoading: viewModel.isLoading
                        ) {
                            Task {
                                await viewModel.login(router: router)
                            }
                        }
                        .padding(.top, 10)
                        
                        Button("Forgot Password?") {
                            // Handle forgot password
                        }
                        .font(AppFont.popinsMedium.ui)
                        .foregroundColor(.getAppColor(.theme))
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer(minLength: 40)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .background(Color.getAppColor(.gray30))
        .alert(for: $viewModel.alertToDisplay)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
