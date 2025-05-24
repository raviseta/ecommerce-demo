//
//  HomeView+ProductListView.swift
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
            ForEach(viewModel.products, id: \.id) { (data: CellDataSource<ProductItemViewModel>) in
                switch data {
                case .loader(_):
                    self.prepareProductListItem(model: .placeholder)
                        .shimmering()
                    
                case .data(let model):
                    tapProduct(for: model)
                }
            }
        }
    }
    
    @ViewBuilder
    private func tapProduct(for model: ProductItemViewModel) -> some View {
        Button {
            self.selectedProduct = model
            viewModel.childContent = .openProductDetail
        } label: {
            self.prepareProductListItem(model: model)
        }
        .buttonStyle(.plain)
        .padding(.bottom, 12)
        .task {
            await viewModel.loadMoreProductsIfNeeded(currentItem: model)
        }
    }
    
    func prepareProductListItem(model: ProductItemViewModel) -> some View {
        ProductListItem(viewModel: model)
            .frame(maxWidth: .infinity)
            .background(Color.getAppColor(.gray30))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
