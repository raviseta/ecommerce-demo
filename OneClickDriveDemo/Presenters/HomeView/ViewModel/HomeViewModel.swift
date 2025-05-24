//
//  HomeViewModel.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
    var selectedCategory: CategoryItemViewModel?
    var categories: [CellDataSource<CategoryItemViewModel>] = []
    var products: [CellDataSource<ProductItemViewModel>] = []
    var errorMessage: String?
    var alertToDisplay: AlertData?
    var taskId = UUID()
    var hasMoreProducts = true
    var minPrice: String = ""
    var maxPrice: String = ""
    var filterCategories: [CategoryItemViewModel] = []
    
    private var offset = 0
    private let limit = 10
    private var isLoading = false
    
    func loadInitialData() async {
        await fetchCategories()
        await fetchProducts(reset: true)
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
                if !categories.isEmpty {
                    self.filterCategories = categories.compactMap { data in
                        switch data {
                        case .data(let vm): return vm
                        default: return nil
                        }
                    }
                }
            }
        } catch {
            errorMessage = error.localizedDescription
            self.alertToDisplay = .init(error: error)
        }
    }
    
    func loadMoreProductsIfNeeded(currentItem item: ProductItemViewModel) async {
        
        guard let lastProduct = products.last?.data else { return }
        if lastProduct.id == item.id && hasMoreProducts && !isLoading {
            await fetchProducts(reset: false)
        }
    }
    
    func fetchProducts(reset: Bool = false) async {
        if reset {
            offset = 0
            hasMoreProducts = true
            products = []
        }
        
        products = [.loader(.init()), .loader(.init()), .loader(.init())]
        
        if isLoading || !hasMoreProducts {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        var params: Parameters = ["offset": offset, "limit": limit]
        
        if let categoryId = selectedCategory?.id {
            params["categoryId"] = categoryId
        }
        if let minPriceDouble = Double(minPrice), minPriceDouble > 0 {
            params["price_min"] = minPriceDouble
        }
        if let maxPriceDouble = Double(maxPrice), maxPriceDouble > 0 {
            params["price_max"] = maxPriceDouble
        }
        
        do {
            let response = try await APIManager.shared.perform(
                path: .products,
                method: .get,
                queryParams: params,
                body: EmptyBody(),
                options: nil,
                responseType: [Product].self
            )
            
            if Task.isCancelled {
                return
            }
            
            await MainActor.run {
                if reset {
                    self.products = response.map { .data(.init(item: $0)) }
                } else {
                    self.products.append(contentsOf: response.map { .data(.init(item: $0)) })
                }
                
                hasMoreProducts = response.count >= limit
            }
            
            offset += limit
            
        } catch is CancellationError {
            print("fetchProducts was cancelled")
        } catch {
            await MainActor.run {
                self.alertToDisplay = .init(error: error)
            }
        }
    }
    
    func refreshProducts() async {
        await fetchProducts(reset: true)
    }
    
    func clearFilters() {
        selectedCategory = nil
        minPrice = ""
        maxPrice = ""
        Task {
            await refreshProducts()
        }
    }
}
