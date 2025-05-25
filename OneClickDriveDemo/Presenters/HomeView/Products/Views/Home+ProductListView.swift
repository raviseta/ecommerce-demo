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
                    productPlaceholder
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
            ProductListItem(viewModel: model)
        }
        .buttonStyle(.plain)
        .padding(.bottom, 12)
        .task {
            await viewModel.loadMoreProductsIfNeeded(currentItem: model)
        }
    }
    
    @ViewBuilder
    var productPlaceholder: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.top, 8)
                .padding(.horizontal, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 16)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 12)
                    .cornerRadius(4)
                
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 20)
                        .cornerRadius(4)
                    
                    Spacer()
                    
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}
