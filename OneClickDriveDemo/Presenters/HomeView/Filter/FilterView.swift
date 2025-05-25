//
//  FilterView.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 23/05/25.
//

import SwiftUI

struct FilterView: View {
    @State var viewModel: FilterViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    CategoryFilterSection(
                        selectedCategory: $viewModel.selectedCategory,
                        categories: viewModel.categories
                    )
                    
                    PriceFilterSection(
                        minPrice: $viewModel.minPrice,
                        maxPrice: $viewModel.maxPrice
                    )
                }
                .frame(maxHeight: .infinity)
                
                FilterActionButtons(
                    onClear: {
                        viewModel.clearFilters()
                    },
                    onApply: {
                        viewModel.applyFilters(apply: (viewModel.selectedCategory, viewModel.minPrice, viewModel.maxPrice))
                    }
                )
                .padding()
            }
            .navigationTitle("Filters")
        }
    }
}

struct CategoryFilterSection: View {
    @Binding var selectedCategory: CategoryItemViewModel?
    let categories: [CategoryItemViewModel]
    
    var body: some View {
        Section(header: Text("Category")) {
            Picker("Select Category", selection: $selectedCategory) {
                Text("All").tag(nil as CategoryItemViewModel?)
                ForEach(categories) { categoryVM in
                    Text(categoryVM.categoryName).tag(Optional(categoryVM))
                }
            }
        }
    }
}

struct PriceFilterSection: View {
    @Binding var minPrice: String
    @Binding var maxPrice: String
    
    var body: some View {
        Section(header: Text("Price Range")) {
            HStack {
                Image(systemName: "dollarsign.circle")
                    .foregroundColor(.green)
                
                TextField("Min Price", text: $minPrice)
                    .keyboardType(.numberPad)
            }
            
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.green)
                
                TextField("Max Price", text: $maxPrice)
                    .keyboardType(.numberPad)
            }
        }
    }
}

struct FilterActionButtons: View {
    let onClear: () -> Void
    let onApply: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button("Clear Filters") {
                onClear()
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            
            Button("Apply Filters") {
                onApply()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}
