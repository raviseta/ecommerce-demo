//
//  HomeViewModel.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selectedCategoryId: Int?
    @Published var categories: [CellDataSource<CategoryItemViewModel>] = []
    @Published var products: [CellDataSource<ProductItemViewModel>] = []
    @Published var errorMessage: String?
    @Published var alertToDisplay: AlertData?
    @Published var taskId = UUID()
    
    private var offset = 0
    private let limit = 10
    private var isLoading = false
    
    func loadInitialData() async {
        await fetchCategories()
        await fetchProducts()
    }
    
    func fetchCategories() async {
        self.categories = [.loader(.init()), .loader(.init()), .loader(.init()) ]
        
        do {
            let response = try await APIManager.shared.perform(
                path: .categories,
                method: .get,
                body: EmptyBody(),
                responseType: [CategoryResponse].self
            )
            
            if Task.isCancelled {
                return
            }
            
            await MainActor.run {
                self.categories = response.map({.data(.init(item: $0))})
                print("categories", categories)
            }
        } catch {
            errorMessage = error.localizedDescription
            self.alertToDisplay = .init(error: error)
        }
    }
    
    func fetchProducts() async {
        
        await MainActor.run {
            self.products = Array(repeating: .loader(.init()), count: 3)
        }
        
        if isLoading {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        var params: Parameters = ["offset": offset, "limit": limit]
        
        guard let token = AppKeyChainManager.shared.accessToken else {
            return
        }
        
        let options = RestOptions(
            headers: ["Authorization": "Bearer \(token)"],
            apiEndpoint: .base
        )
        
        if let categoryId = selectedCategoryId {
            params["categoryId"] = categoryId
        }
        
        do {
            let response = try await APIManager.shared.perform(
                path: .products,
                method: .get,
                queryParams: params,
                body: EmptyBody(),
                options: options,
                responseType: [Product].self
            )
            
            if Task.isCancelled {
                return
            }
            
            await MainActor.run {
                self.products = response.map { .data(.init(item: $0)) }
            }
            
            offset += limit
            
        } catch is CancellationError {
            print("⚠️ fetchProducts was cancelled")
        } catch {
            await MainActor.run {
                self.alertToDisplay = .init(error: error)
            }
        }
    }
}
