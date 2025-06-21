//
//  CreateNewProductViewModel.swift
//  MyCalories
//
//  Created by Иван Семикин on 21/06/2025.
//

import Foundation

final class CreateNewProductViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var calories: String = ""
    @Published var protein: String = ""
    @Published var fats: String = ""
    @Published var carbohydrates: String = ""
    
    private let realm: RealmManager
    
    init(realmManager: RealmManager) {
        realm = realmManager
    }
    
    func isReadyForSave() -> Bool {
        !name.isEmpty
        && !calories.isEmpty
        && !protein.isEmpty
        && !fats.isEmpty
        && !carbohydrates.isEmpty
    }
    
    func saveProduct() {
        guard isReadyForSave() else { return }
        
        let product = Product()
        product.name = name
        product.calories = Double(calories) ?? 0
        product.protein = Double(protein) ?? 0
        product.fats = Double(fats) ?? 0
        product.carbohydrates = Double(carbohydrates) ?? 0
        
        realm.addNewProductToBase(product)
    }
}
