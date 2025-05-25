//
//  ProductDetailView.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 24/05/25.
//

import SwiftUI

struct ProductDetailView: View {
    @Environment(\.dismiss) var dismiss
    var viewModel: ProductDetailViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ProductImageCarousel(images: viewModel.images)
                    
                    ProductInfoSection(
                        title: viewModel.title,
                        price: viewModel.price,
                        description: viewModel.description
                    )
                }
            }
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ProductImageCarousel: View {
    let images: [String]
    
    var body: some View {
        if !images.isEmpty {
            TabView {
                ForEach(images, id: \.self) { imageUrlString in
                    if let url = URL(string: imageUrlString) {
                        CachedAsyncImage(url: url)
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 300)
                            .clipped()
                    }
                }
            }
            .frame(height: 300)
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        } else {
            ProductPlaceholderImage()
        }
    }
}

struct ProductPlaceholderImage: View {
    var body: some View {
        Image(systemName: "photo.on.rectangle.angled")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 300)
            .foregroundColor(.gray)
    }
}

struct ProductInfoSection: View {
    let title: String
    let price: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ProductTitleSection(title: title, price: price)
            
            Divider()
            
            ProductDescriptionSection(description: description)
        }
        .padding(.horizontal)
    }
}

struct ProductTitleSection: View {
    let title: String
    let price: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(price)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.green)
        }
    }
}

struct ProductDescriptionSection: View {
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.title3)
                .fontWeight(.medium)
            
            Text(description)
                .font(.body)
        }
    }
}
