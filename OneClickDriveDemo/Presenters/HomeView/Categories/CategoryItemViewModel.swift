//
//  CategoryItemViewModel.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 22/05/25.
//

import Foundation

class CategoryItemViewModel: Identifiable, ObservableObject {
    let id: Int
    let categoryName: String
    let imageUrl: String
    
    init(
        id: Int,
        categoryName: String,
        imageUrl: String
    ) {
        self.id = id
        self.categoryName = categoryName
        self.imageUrl = imageUrl
    }
}

extension CategoryItemViewModel {
    static var placeholder: CategoryItemViewModel {
        return .init(
            id: Int.random(in: 1...999_999),
            categoryName: .dummyLongText,
            imageUrl: "https://example.com/food.png"
        )
    }
}

extension CategoryItemViewModel {
    
    convenience init(item: CategoryResponse) {
        self.init(
            id: item.id,
            categoryName: item.name,
            imageUrl: item.image
        
        )
    }
}
