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
    @Published var selectedDate: Date? = Date()
    
    var weight: Int {
        Int(weightText) ?? 0
    }
    
    init(realmManager: RealmManager, selectedProduct: Product) {
        self.realmManager = realmManager
        self.selectedProduct = selectedProduct
    }
}
