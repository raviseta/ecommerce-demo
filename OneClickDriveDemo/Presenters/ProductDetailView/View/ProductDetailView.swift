//
//  ProductDetailView.swift
//  OneClickDriveDemo
//
//  Created by Alex Carmack on 24/05/25.
//

import SwiftUI

struct ProductDetailView: View {
     var viewModel: ProductDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Image Carousel / Display
                if !viewModel.images.isEmpty {
                    TabView {
                        ForEach(viewModel.images, id: \.self) { imageUrlString in
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
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .foregroundColor(.gray)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(viewModel.price)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    Divider()

                    Text("Description")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    Text(viewModel.description)
                        .font(.body)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Helper for image caching if not already globally available
// (Assuming CachedAsyncImage is available from your project like in HomeView)
