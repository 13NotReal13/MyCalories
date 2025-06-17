//
//  HomeViewModel.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import Foundation
import RealmSwift

final class HomeViewModel: ObservableObject {
    @Published var filteredProducts: [Product] = []
    @Published var isMenuOpen: Bool = false
    
    @Published var protein: (used: Int, goal: Int) = (0, 0)
    @Published var fats: (used: Int, goal: Int) = (0, 0)
    @Published var carbohydrates: (used: Int, goal: Int) = (0, 0)
    @Published var calories: (used: Int, goal: Int) = (0, 0)
    @Published var water: (used: Int, goal: Int) = (0, 0)
    
    @Published var searchText: String = "" {
        didSet {
            applyFilter()
        }
    }
    
    private let realm: RealmManager
    private var allProducts: Results<Product>?
    
    init(realmManager: RealmManager) {
        self.realm = realmManager
        loadProducts()
        fetchUsedTodayNutrients()
        fetchRecommendedValues()
    }
    
    func isProgressBarUnlocked() -> Bool {
        realm.fetchPerson() != nil
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
        realm.fetchAllProducts { [weak self] products in
            DispatchQueue.main.async {
                self?.allProducts = products
                self?.filteredProducts = Array(products)
            }
        }
    }
    
    func fetchUsedTodayNutrients() {
        let todayNutrients = realm.fetchTodayTotalNutrients()
        protein.used = Int(todayNutrients.proteins)
        fats.used = Int(todayNutrients.fats)
        carbohydrates.used = Int(todayNutrients.carbohydrates)
        calories.used = Int(todayNutrients.calories)
        water.used = Int(todayNutrients.water)
    }

    func fetchRecommendedValues() {
        guard let recommendedValues = realm.fetchRecommendedProgramm() else { return }
        protein.goal = recommendedValues.proteins
        fats.goal = recommendedValues.fats
        carbohydrates.goal = recommendedValues.carbohydrates
        calories.goal = recommendedValues.calories
        water.goal = recommendedValues.water
        print("Ok")
    }
}
