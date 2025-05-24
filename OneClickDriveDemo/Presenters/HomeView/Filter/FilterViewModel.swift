//
//  FilterViewModel.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 24/05/25.
//

import Foundation
import Observation

@Observable
final class FilterViewModel {
    var selectedCategory: CategoryItemViewModel?
    var minPrice: String = ""
    var maxPrice: String = ""
    var categories: [CategoryItemViewModel]
    private let actions: Actions
    
    struct Actions {
        var onApply: ((CategoryItemViewModel?, String, String)) -> Void
        var onClear: () -> Void
    }
    
    init(
        categories: [CategoryItemViewModel],
        selectedCategory: CategoryItemViewModel?,
        minPrice: String,
        maxPrice: String,
        actions: Actions
    ) {
        self.categories = categories
        self.selectedCategory = selectedCategory
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.actions = actions
    }
    
    func clearFilters() {
        selectedCategory = nil
        minPrice = ""
        maxPrice = ""
    }
    
    func applyFilters(apply: (CategoryItemViewModel?, String, String)) {
        actions.onApply(apply)
    }
}
