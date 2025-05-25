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
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    
                    categoriesSection
                    
                    productsSection
                }
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
            .navigationBarHidden(true)
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
    
    @ViewBuilder
    var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome Back!")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Discover amazing products")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    viewModel.childContent = .openFilter
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Button(action: {
                    showLogoutAlert = true
                }) {
                    Image(systemName: "power")
                        .font(.title3)
                        .foregroundColor(.red)
                        .frame(width: 44, height: 44)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Categories")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    if viewModel.categories.isEmpty {
                        emptyStateView
                    } else {
                        ForEach(viewModel.categories, id: \.id) { data in
                            switch data {
                            case .loader(_):
                                categoryPlaceholder
                                    .shimmering()
                                
                            case .data(let model):
                                categoryItem(model: model)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 24)
    }
    
    @ViewBuilder
    var productsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Products")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 16) {
                productListView
            }
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    func categoryItem(model: CategoryItemViewModel) -> some View {
        let isSelected = viewModel.selectedCategory?.id == model.id
        
        VStack(spacing: 12) {
            if let url = URL(string: model.imageUrl) {
                CachedAsyncImage(url: url)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                    )
            }
            
            Text(model.categoryName)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .blue : .primary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100)
        .onTapGesture {
            if viewModel.selectedCategory?.id == model.id {
                viewModel.selectedCategory = nil
            } else {
                viewModel.selectedCategory = model
            }
            Task {
                await viewModel.refreshProducts()
            }
        }
    }
    
    @ViewBuilder
    var categoryPlaceholder: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 80, height: 80)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 12)
                .cornerRadius(6)
        }
        .frame(width: 100)
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
