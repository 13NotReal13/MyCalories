//
//  ProductsList.swift
//  MyCalories
//
//  Created by Иван Семикин on 08/04/2024.
//

import Foundation
import RealmSwift

final class UsedProductsList: Object {
    @Persisted var usedProducts = List<Product>()
}

final class HistoryOfProducts: Object {
    @Persisted var date = Date()
    @Persisted var usedProducts = List<Product>()
}

final class Product: Object {
    @Persisted var name = ""
    @Persisted var protein = 0.0
    @Persisted var fats = 0.0
    @Persisted var carbohydrates = 0.0
    @Persisted var calories = 0.0
    @Persisted var date = Date()
    @Persisted var weight = 0.0
    @Persisted var color = "colorApp"
}
