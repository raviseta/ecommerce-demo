//
//  CategoryListItem.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 24/05/25.
//

import SwiftUI

struct CategoryListItem: View {
    
    @ObservedObject var viewModel: CategoryItemViewModel
    
    var body: some View {
        GeometryReader { proxy in
            
            imageView(with: proxy)
            
            titleView
            
        }
        .cornerRadius(8.0)
    }
}

private extension CategoryListItem {
    
    @ViewBuilder
    func imageView(with proxy: GeometryProxy) -> some View {
        if let url = URL(string: viewModel.imageUrl) {
            CachedAsyncImage(url: url)
                .frame(width: proxy.size.width, height: proxy.size.height - 10)
        }
    }
    
    @ViewBuilder
    var titleView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(viewModel.categoryName)
                .foregroundStyle(Color.black)
        }
        
    }
}
