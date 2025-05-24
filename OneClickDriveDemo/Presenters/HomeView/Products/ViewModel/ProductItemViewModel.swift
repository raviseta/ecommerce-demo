//
//  ProductItemViewModel.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import Foundation

class ProductItemViewModel: Identifiable, ObservableObject {
    let id: Int
    let name: String
    let imageUrl: String
    let price: Double
    let description: String
    let images: [String]

    init(
        id: Int,
        name: String,
        imageUrl: String,
        price: Double,
        description: String,
        images: [String]
    ) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.price = price
        self.description = description
        self.images = images
    }
}

extension ProductItemViewModel {
    static var placeholder: ProductItemViewModel {
        return .init(
            id: Int.random(in: 1...999_999),
            name: .dummyLongText,
            imageUrl: "https://example.com/food.png",
            price: Double.random(in: 1...999_999),
            description: .dummyLongText,
            images: []
        )
    }
}

extension ProductItemViewModel {
    
    convenience init(item: Product) {
        self.init(
            id: item.id,
            name: item.title,
            imageUrl: item.images.first ?? "https://example.com/food.png",
            price: item.price,
            description: item.description,
            images: []
        )
    }
}
