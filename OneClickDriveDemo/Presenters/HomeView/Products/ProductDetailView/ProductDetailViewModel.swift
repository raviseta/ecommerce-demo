//
//  ProductDetailViewModel.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 24/05/25.
//

import Foundation
import SwiftUI

class ProductDetailViewModel {
    var product: ProductItemViewModel

    init(product: ProductItemViewModel) {
        self.product = product
    }

    var title: String { product.name }
    var description: String { product.description }
    var price: String { String(format: "$%.2f", product.price) }
    var images: [String] { product.images }
}
