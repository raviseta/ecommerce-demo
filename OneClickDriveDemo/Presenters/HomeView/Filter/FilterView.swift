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
                    Section(header: Text("Category")) {
                        Picker("Select Category", selection: $viewModel.selectedCategory) {
                            Text("All").tag(nil as CategoryItemViewModel?)
                            ForEach(viewModel.categories) { categoryVM in
                                Text(categoryVM.categoryName).tag(Optional(categoryVM))
                            }
                        }
                    }
                    
                    Section(header: Text("Price Range")) {
                        TextField("Min Price", text: $viewModel.minPrice)
                            .keyboardType(.numberPad)
                        TextField("Max Price", text: $viewModel.maxPrice)
                            .keyboardType(.numberPad)
                    }
                }
                .frame(maxHeight: .infinity)

                HStack(spacing: 16) {
                    Button("Clear Filters") {
                        viewModel.clearFilters()
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                    Button("Apply Filters") {
                        viewModel.applyFilters(apply: (viewModel.selectedCategory, viewModel.minPrice, viewModel.maxPrice))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Filters")
        }
    }
}
