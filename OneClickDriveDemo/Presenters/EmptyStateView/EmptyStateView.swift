//
//  EmptyStateView.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 21/05/25.
//

import SwiftUI
import AppUtil

struct EmptyStateView: View {
   
    let viewModel: EmptyStateViewModel
   
    init(viewModel: EmptyStateViewModel) {
       self.viewModel = viewModel
   }
   
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.getAppColor(.theme).opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "cart.badge.questionmark")
                    .font(.system(size: 50))
                    .foregroundColor(.getAppColor(.theme))
            }
            .padding(.top, 40)
            
            VStack(spacing: 12) {
                Text(viewModel.title)
                    .font(AppFont.title2.ui)
                    .foregroundColor(.getAppColor(.primaryTextColor))
                    .multilineTextAlignment(.center)
                
                Text(viewModel.message)
                    .font(AppFont.description.ui)
                    .foregroundColor(.getAppColor(.primaryTextColor).opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.getAppColor(.gray30))
    }
}
