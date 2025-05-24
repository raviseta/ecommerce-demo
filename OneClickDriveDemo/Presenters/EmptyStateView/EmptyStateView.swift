//
//  EmptyStateView.swift
//  RecipeApp
//
//  Created by Ravi Seta on 27/01/25.
//

import SwiftUI

struct EmptyStateView: View {
   
    let viewModel: EmptyStateViewModel
   
    init(viewModel: EmptyStateViewModel) {
       self.viewModel = viewModel
   }
   
    var body: some View {
       ZStack(alignment: .center) {
           VStack(spacing: 0) {
               
               Image(viewModel.image.rawValue)
                   .resizable()
                   .scaledToFit()
                   .frame(width: viewModel.size.width, height: viewModel.size.height)
                   .padding(.bottom, 10)
               
               Text(viewModel.title)
                   .foregroundStyle(Color.black)
                   .frame(maxWidth: .infinity,alignment: .center)
                   .padding(.top, 12)
               
               Text(viewModel.message)
                   .foregroundStyle(Color.black)
                   .frame(maxWidth: .infinity,alignment: .center)
                   .padding(.top, 4)
           }
           .padding(.horizontal, 16)
           .padding(.vertical, 16)
       }
   }
}
