//
//  HomeView.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State private var hasLoadedInitialData = false
    
    var body: some View {
        NavigationView {
            GeometryReader { containerProxy in

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            categoryView(for: containerProxy)
                                .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                    }
                    .frame(height: 400) // 👈 Add this fixed height!
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        
                        productListView
                    }
                    .padding(.horizontal)
                }
                .refreshable {
                    viewModel.taskId = UUID()
                }
                .task(id: viewModel.taskId) {
                    if !hasLoadedInitialData {
                        hasLoadedInitialData = true
                    }
                    await viewModel.loadInitialData()
                }
                .alert(for: $viewModel.alertToDisplay)
                .navigationTitle("Home")
            }
        }
    }
    
    @ViewBuilder
    var productListView: some View {
        if viewModel.products.isEmpty {
            
            // emptyStateView
            
        } else {
            ForEach(viewModel.products, id: \.id) { data in
                switch data {
                case .loader(_):
                    self.prepareProductListItem(model: .placeholder)
                        .shimmering()
                    
                case .data(let model):
                    self.prepareProductListItem(model: model)
                        .padding(.bottom, 12)
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
