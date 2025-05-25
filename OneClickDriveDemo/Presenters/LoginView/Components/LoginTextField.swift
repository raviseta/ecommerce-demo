//
//  LoginTextField.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 25/05/25.
//

import SwiftUI
import AppUtil

struct LoginTextField: View {
    let title: String
    let placeholder: String
    let systemImage: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    
    init(
        title: String,
        placeholder: String,
        systemImage: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        isSecure: Bool = false
    ) {
        self.title = title
        self.placeholder = placeholder
        self.systemImage = systemImage
        self._text = text
        self.keyboardType = keyboardType
        self.isSecure = isSecure
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppFont.popinsMedium.ui)
                .foregroundColor(.getAppColor(.primaryTextColor))
            
            HStack {
                Image(systemName: systemImage)
                    .foregroundColor(.getAppColor(.theme))
                    .frame(width: 20)
                
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                            .keyboardType(keyboardType)
                            .autocapitalization(.none)
                    }
                }
                .foregroundColor(.getAppColor(.primaryTextColor))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.getAppColor(.grayBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.getAppColor(.theme).opacity(0.3), lineWidth: 1)
            )
        }
    }
}
