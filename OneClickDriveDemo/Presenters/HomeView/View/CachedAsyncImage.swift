//
//  CachedAsyncImage.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    
    @State private var image: UIImage? = nil
    @State private var isLoading = false
    let url: URL
    let placeholder: Image
    let cache = ImageCache.shared
    
    init(
        url: URL,
        placeholder: Image = Image.init(Images.placeHolderImage.rawValue)
    ) {
        self.url = url
        self.placeholder = placeholder
    }

    var body: some View {
        ZStack {
            if let cachedImage = image {
                Image(uiImage: cachedImage)
                    .resizable()
                    .scaledToFit()
            } else {
                placeholder
                    .resizable()
                    .scaledToFit()
            }
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .onAppear {
            Task {
                await loadImage()
            }
        }
    }

    func loadImage() async {
        if let cachedImage = cache.getImage(forKey: url.absoluteString) {
            self.image = cachedImage
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let downloadedImage = UIImage(data: data) {
                cache.saveImage(downloadedImage, forKey: url.absoluteString)
                self.image = downloadedImage
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }

}
