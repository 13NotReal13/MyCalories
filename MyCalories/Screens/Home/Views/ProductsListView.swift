//
//  ProductsListView.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import SwiftUI

struct ProductsListView: View {
    var filteredProducts: [Product]
    
    var body: some View {
        List(filteredProducts, id: \.self) { product in
            VStack(alignment: .leading) {
                Text(product.name)
                
                HStack {
                    Spacer()
                    Text("Б: \(String(format: "%.2f", product.protein))")
                        .customFont()
                    Spacer()
                    Text("Ж: \(String(format: "%.2f", product.fats))")
                        .customFont()
                    Spacer()
                    Text("У: \(String(format: "%.2f", product.carbohydrates))")
                    Spacer()
                }
                
                Text("Ккал: \(String(format: "%.2f", product.calories))")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
                
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
        .shadow(color: .black.opacity(0.5), radius: 10)
    }
}

#Preview {
    ProductsListView(filteredProducts: HomeViewModel.prewiew.filteredProducts)
}
