//
//  ProductsListView.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import SwiftUI

struct ProductsListView: View {
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 6) {
                ForEach(homeViewModel.filteredProducts, id: \.self) { product in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(product.name)
                            .customFont()
                        
                        VStack(spacing: 4) {
                            HStack {
                                Spacer()
                                
                                Text("белки: \(String(format: "%.2f", product.protein))")
                                
                                Spacer()
                                
                                Text("жиры: \(String(format: "%.2f", product.fats))")
                                
                                Spacer()
                                
                                Text("углеводы: \(String(format: "%.2f", product.carbohydrates))")
                                
                                Spacer()
                            }
                            
                            Text("кКал: \(String(format: "%.2f", product.calories)) на 100 г.")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .customFont(size: 13, color: .gray)
                        
                        Divider()
                    }
                    .onTapGesture {
                        navigationCoordinator.presentModal(.addProduct(product))
                    }
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
//    ProductsListView(filteredProducts: HomeViewModel.filteredProducts)
}
