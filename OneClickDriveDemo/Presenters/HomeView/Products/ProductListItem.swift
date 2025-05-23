//
//  ProductListItem.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import SwiftUICore

struct ProductListItem: View {
    
    @ObservedObject var viewModel: ProductItemViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            imageView
            
            infoView
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(8.0)
    }
}

private extension ProductListItem {
    
    @ViewBuilder
    var imageView: some View {
        if let url = URL(string: viewModel.imageUrl) {
            CachedAsyncImage(url: url)
                .frame(width: imageSize.width, height: imageSize.height)
        }
    }
    
    @ViewBuilder
    var infoView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(viewModel.name)
                .foregroundStyle(Color.black)
            
            Text("$\(viewModel.price, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    var imageSize: CGSize {
        return .init(width: 80, height: 80)
    }
}
