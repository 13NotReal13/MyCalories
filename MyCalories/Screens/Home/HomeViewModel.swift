//
//  HomeViewModel.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import Foundation
import RealmSwift

final class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filteredProducts: [Product] = []
    @Published var isMenuOpen: Bool = false
    
    @Published var protein: (used: Int, goal: Int) = (0, 0)
    @Published var fats: (used: Int, goal: Int) = (0, 0)
    @Published var carbohydrates: (used: Int, goal: Int) = (0, 0)
    @Published var calories: (used: Int, goal: Int) = (0, 0)
    @Published var water: (used: Int, goal: Int) = (0, 0)
    
    private var allProducts: Results<Product>?
    
    init() {
//        loadProducts()
    }
    
    private func loadProducts() {
        StorageManager.shared.fetchAllProducts { [weak self] products in
            self?.allProducts = products
        }
    }
}

// fake data for prewiew
extension HomeViewModel {
    static var prewiew: HomeViewModel {
        let viewModel = HomeViewModel()
        
        viewModel.searchText =  ""
        viewModel.isMenuOpen = false
        
        viewModel.filteredProducts = [
            Product.fake(name: "Авокадо"),
            Product.fake(name: "Яйцо варёное"),
            Product.fake(name: "Рис коричневый")
        ]
        
        viewModel.protein = (used: 50, goal: 120)
        viewModel.fats = (used: 30, goal: 60)
        viewModel.carbohydrates = (used: 100, goal: 200)
        viewModel.calories = (used: 1200, goal: 2200)
        viewModel.water = (used: 900, goal: 2000)
        
        return viewModel
    }
}
