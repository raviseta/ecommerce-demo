//
//  LoginHeader.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 25/05/25.
//

import SwiftUI
import AppUtil

struct LoginHeader: View {
    let title: String
    let subtitle: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundColor(.getAppColor(.theme))
                .padding(.top, 60)
            
            Text(title)
                .font(AppFont.largeTitle.ui)
                .fontWeight(.bold)
                .foregroundColor(.getAppColor(.primaryTextColor))
            
            Text(subtitle)
                .font(AppFont.description.ui)
                .foregroundColor(.getAppColor(.primaryTextColor).opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}
