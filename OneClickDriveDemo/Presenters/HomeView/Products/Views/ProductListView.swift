//
//  File.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 24/05/25.
//

import SwiftUI

extension HomeView {
    @ViewBuilder
    var productListView: some View {
        
        if viewModel.products.isEmpty {
            
            emptyStateView
            
        } else {
            ForEach(viewModel.products, id: \.id) { data in
                switch data {
                case .loader(_):
                    self.prepareProductListItem(model: .placeholder)
                        .shimmering()
                    
                case .data(let model):
                    self.prepareProductListItem(model: model)
                        .padding(.bottom, 12)
                        .task {
                            await viewModel.loadMoreProductsIfNeeded(currentItem: model)
                        }
                    
                }
            }
        }
    }
    
    func prepareProductListItem(model: ProductItemViewModel) -> some View {
        ProductListItem(viewModel: model)
            .frame(maxWidth: .infinity)
            .background(Color.getAppColor(.gray30))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
