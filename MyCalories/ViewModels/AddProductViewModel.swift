//
//  AddProductViewModel.swift
//  MyCalories
//
//  Created by Иван Семикин on 10/06/2025.
//

import Foundation

final class AddProductViewModel: ObservableObject {
    private let realmManager: RealmManager
    
    @Published var selectedProduct: Product
    @Published var isPresentingDatePicker = false
    @Published var weightText: String = ""
    @Published var selectedDate: Date = Date()
    
    var weight: Int {
        Int(weightText) ?? 0
    }
    
    init(realmManager: RealmManager, selectedProduct: Product) {
        self.realmManager = realmManager
        self.selectedProduct = selectedProduct
    }
    
    func isReadyForAdd() -> Bool {
        weight > 0
    }
    
    func saveProductToHistory() {
//        guard weight > 0, let selectedDate else { return }

        let newProduct = Product()
        newProduct.name = selectedProduct.name
        newProduct.protein = (selectedProduct.protein / 100) * Double(weight)
        newProduct.fats = (selectedProduct.fats / 100) * Double(weight)
        newProduct.carbohydrates = (selectedProduct.carbohydrates / 100) * Double(weight)
        newProduct.calories = (selectedProduct.calories / 100) * Double(weight)
        newProduct.color = selectedProduct.color
        newProduct.date = selectedDate
        newProduct.weight = Double(weight)
        newProduct.index = selectedProduct.index

        realmManager.addProductToHistory(newProduct)
    }
}
