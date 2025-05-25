//
//  ProductListItem.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import SwiftUI
import AppUtil

struct ProductListItem: View {
    
    @ObservedObject var viewModel: ProductItemViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            imageView
            
            infoView
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

private extension ProductListItem {
    
    @ViewBuilder
    var imageView: some View {
        if let url = URL(string: viewModel.imageUrl) {
            CachedAsyncImage(url: url)
                .aspectRatio(contentMode: .fill)
                .frame(height: 140)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.top, 8)
                .padding(.horizontal, 8)
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.top, 8)
                .padding(.horizontal, 8)
        }
    }
    
    @ViewBuilder
    var infoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.name)
                .font(AppFont.bodyMedium.ui)
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Text(viewModel.description)
                .font(AppFont.description.ui)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            HStack {
                Text("$\(viewModel.price, specifier: "%.2f")")
                    .font(AppFont.title3.ui)
                    .foregroundColor(Color.getAppColor(.theme))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "plus.circle.fill")
                    .font(AppFont.title3.ui)
                    .foregroundColor(Color.getAppColor(.theme))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
