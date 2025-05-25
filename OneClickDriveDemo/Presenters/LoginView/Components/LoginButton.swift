//
//  LoginButton.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 25/05/25.
//

import SwiftUI
import AppUtil

struct LoginButton: View {
    let title: String
    let loadingTitle: String
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 18))
                }
                
                Text(isLoading ? loadingTitle : title)
                    .font(AppFont.title3.ui)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.getAppColor(.theme),
                        Color.getAppColor(.theme).opacity(0.8)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
            .shadow(color: Color.getAppColor(.theme).opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .disabled(isLoading)
    }
}
