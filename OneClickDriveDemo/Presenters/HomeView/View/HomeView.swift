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
    @State private var showFilterSheet = false
    @State private var showLogoutAlert = false
    
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
                    showFilterSheet = true
                }) {
                    Image(systemName: "slider.horizontal.3")
                }
                )
                .sheet(isPresented: $showFilterSheet) {
                    FilterView(
                        viewModel: FilterViewModel(
                            categories: viewModel.filterCategories,
                            selectedCategory: viewModel.selectedCategory,
                            minPrice: viewModel.minPrice,
                            maxPrice: viewModel.maxPrice,
                            actions: .init(
                            onApply: { apply in
                                viewModel.selectedCategory = apply.0
                                viewModel.minPrice = apply.1
                                viewModel.maxPrice = apply.2

                                showFilterSheet = false
                                Task {
                                    await viewModel.refreshProducts()
                                }
                            }, onClear: {
                                showFilterSheet = false
                                viewModel.clearFilters() // This already triggers a refresh via taskId
                            })))
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
