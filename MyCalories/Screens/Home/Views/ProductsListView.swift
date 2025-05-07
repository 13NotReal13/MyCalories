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
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(filteredProducts, id: \.self) { product in
                    Text(product.name)
                        .customFont()
                    
                    VStack(spacing: 4) {
                        HStack {
                            Text("БЕЛКИ: \(String(format: "%.2f", product.protein))")
                            Spacer()
                            Text("ЖИРЫ: \(String(format: "%.2f", product.fats))")
                            Spacer()
                            Text("УГЛЕВОДЫ: \(String(format: "%.2f", product.carbohydrates))")
                        }
                        
                        Text("Ккал: \(String(format: "%.2f", product.calories)) НА 100 Г.")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .customFont(size: 13, color: .gray)
                    
                    Divider()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: 8)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

#Preview {
    ProductsListView(filteredProducts: HomeViewModel.prewiew.filteredProducts)
}
