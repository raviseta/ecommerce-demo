//
//  CategoryView.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import SwiftUICore
import SwiftUI

extension HomeView {
    func categoryView(for proxy: GeometryProxy)-> some View {
        LazyHStack {
            
            if viewModel.categories.isEmpty {
                
                // emptyStateView
                
            } else {
                ForEach(viewModel.categories, id: \.id) { data in
                    switch data {
                    case .loader(_):
                        self.prepareCategoryItem(model: .placeholder)
                            .shimmering()
                        
                    case .data(let model):
                        self.prepareCategoryItem(model: model)
                            .frame(width: proxy.size.width * 0.9)
                    }
                }
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 24)
    }
    
    func prepareCategoryItem(model: CategoryItemViewModel) -> some View {
        CategoryListItem(viewModel: model)
            .background(Color.getAppColor(.gray30))
    }
}

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
    
    var imageSize: CGSize {
        return .init(width: 80, height: 80)
    }
}
