//
//  HomeViewModel.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import Foundation
import RealmSwift

final class HomeViewModel: ObservableObject {
    private let realmManager: RealmManager
    
    @Published var searchText: String = "" {
        didSet {
            applyFilter()
        }
    }
    
    @Published var filteredProducts: [Product] = []
    @Published var isMenuOpen: Bool = false
    
    @Published var protein: (used: Int, goal: Int) = (0, 0)
    @Published var fats: (used: Int, goal: Int) = (0, 0)
    @Published var carbohydrates: (used: Int, goal: Int) = (0, 0)
    @Published var calories: (used: Int, goal: Int) = (0, 0)
    @Published var water: (used: Int, goal: Int) = (0, 0)
    
    private var allProducts: Results<Product>?
    
    init(realmManager: RealmManager) {
        self.realmManager = realmManager
        loadProducts()
    }
    
    private func applyFilter() {
        guard let allProducts = allProducts else {
            filteredProducts = []
            return
        }
        
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            filteredProducts = Array(allProducts)
        } else {
            let predicate = NSPredicate(format: "name CONTAINS[c] %@", trimmed)
            filteredProducts = Array(allProducts.filter(predicate))
        }
    }
    
    private func loadProducts() {
        realmManager.fetchAllProducts { [weak self] products in
            DispatchQueue.main.async {
                self?.allProducts = products
                self?.filteredProducts = Array(products)
            }
        }
    }

    private func fetchRecommendedValues() {
        guard let recommendedValues = realmManager.fetchRecommendedProgramm() else { return }
        protein.goal = recommendedValues.proteins
        fats.goal = recommendedValues.fats
        carbohydrates.goal = recommendedValues.carbohydrates
        calories.goal = recommendedValues.calories
    }
}
