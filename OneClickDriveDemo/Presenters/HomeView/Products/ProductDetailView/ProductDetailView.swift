//
//  ProductDetailView.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 24/05/25.
//

import SwiftUI
import AppUtil

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
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(AppFont.title3.ui)
                            .foregroundColor(.gray)
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
                .font(AppFont.largeTitle.ui)

            Text(price)
                .font(AppFont.title2.ui)
                .foregroundColor(.green)
        }
    }
}

struct ProductDescriptionSection: View {
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(AppFont.title3.ui)
            
            Text(description)
                .font(AppFont.description.ui)

        }
    }
}
