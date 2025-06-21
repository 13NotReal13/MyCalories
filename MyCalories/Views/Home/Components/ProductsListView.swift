//
//  ProductsListView.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import SwiftUI
import RealmSwift

struct ProductsListView: View {
    @EnvironmentObject private var coordinator: Coordinator

    @ObservedResults(
        Product.self,
        sortDescriptor: SortDescriptor(keyPath: "index", ascending: true)
    ) var products

    var body: some View {
        List {
            ForEach(products, id: \.self) { product in
                ProductCellView(product: product)
                    .onTapGesture {
                        coordinator.present(sheet: .addProduct(product))
                    }
            }
        }
        .listStyle(.plain)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundListView())
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct ProductCellView: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(product.name)
                .customFont()
            
            VStack(spacing: 4) {
                HStack {
                    Spacer()
                    Text("белки: \(product.protein.formatted(.number.precision(.fractionLength(2))))")
                    Spacer()
                    Text("жиры: \(product.fats.formatted(.number.precision(.fractionLength(2))))")
                    Spacer()
                    Text("углеводы: \(product.carbohydrates.formatted(.number.precision(.fractionLength(2))))")
                    Spacer()
                }
                
                Text("кКал: \(product.calories.formatted(.number.precision(.fractionLength(2)))) на 100 г.")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .customFont(size: 13, color: .gray)
        }
    }
}
