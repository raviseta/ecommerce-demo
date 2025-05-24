//
//  CategoryView.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import SwiftUI

extension HomeView {
    func categoryView(for proxy: GeometryProxy)-> some View {
        LazyHStack {
            
            if self.viewModel.categories.isEmpty {
                
                emptyStateView
                
            } else {
                ForEach(self.viewModel.categories, id: \.id) { data in
                    switch data {
                    case .loader(_):
                        self.prepareCategoryItem(model: .placeholder, isSelected: false) {}
                            .frame(width: proxy.size.width * 0.9)
                            .shimmering()
                        
                    case .data(let model):
                        self.prepareCategoryItem(
                            model: model,
                            isSelected: self.viewModel.selectedCategory?.id == model.id,
                            action: {
                                if self.viewModel.selectedCategory?.id == model.id {
                                    self.viewModel.selectedCategory = nil
                                } else {
                                    self.viewModel.selectedCategory = model
                                }
                                Task {
                                    await self.viewModel.refreshProducts()
                                }
                            }
                        )
                        .frame(width: proxy.size.width * 0.9)
                    }
                }
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 24)
    }
    
    func prepareCategoryItem(model: CategoryItemViewModel, isSelected: Bool, action: @escaping () -> Void) -> some View {
        CategoryListItem(viewModel: model)
            .background(Color.getAppColor(.gray30))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .onTapGesture {
                action()
            }
    }
}
