//
//  HomeView.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel = HomeViewModel()
    @EnvironmentObject var router: AppRouter
    @State private var hasLoadedInitialData = false
    @State private var showLogoutAlert = false
    @State var selectedProduct: ProductItemViewModel?
    
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
                    .frame(height: 400)
                    
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
                .navigationBarItems(leading:
                                        Button(action: {
                    showLogoutAlert = true
                }) {
                    Image(systemName: "power")
                }
                                    ,trailing:
                                        Button(action: {
                    viewModel.childContent = .openFilter
                }) {
                    Image(systemName: "slider.horizontal.3")
                }
                )
                .sheet(isPresented: viewModel.isBottomSheetPresenting) {
                    filterView
                }
                .fullScreenCover(isPresented: viewModel.isFullScreenPresenting) {
                    if let selectedProduct {
                        ProductDetailView(
                            viewModel: ProductDetailViewModel(product: selectedProduct)
                        )
                    }
                }
                .alert("Logout", isPresented: $showLogoutAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Logout", role: .destructive) {
                        AppKeyChainManager.shared.deleteAll()
                        router.showLogin()
                    }
                } message: {
                    Text("Are you sure you want to logout?")
                }
            }
        }
    }
    
    @ViewBuilder
    var filterView: some View {
        FilterView(
            viewModel: FilterViewModel(
                categories: viewModel.filterCategories,
                selectedCategory: viewModel.selectedCategory,
                minPrice: viewModel.minPrice,
                maxPrice: viewModel.maxPrice,
                actions: .init(
                    onApply: { apply in
                        viewModel.selectedCategory = apply.category
                        viewModel.minPrice = apply.minPrice
                        viewModel.maxPrice = apply.maxPrice
                        viewModel.childContent = .none
                        Task {
                            await viewModel.refreshProducts()
                        }
                    }, onClear: {
                        viewModel.clearFilters()
                    })))
    }
}



@ViewBuilder
var emptyStateView: some View {
    EmptyStateView(
        viewModel: .init(
            image: .placeHolderImage,
            title: applicationName,
            message: ErrorMessage.emptyState.rawValue,
            size: .init(width: 72, height: 72)
        )
    )
    .frame(maxHeight: .infinity)
}
