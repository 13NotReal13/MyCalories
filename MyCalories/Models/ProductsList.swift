//
//  ProductsList.swift
//  MyCalories
//
//  Created by Иван Семикин on 08/04/2024.
//

import Foundation
import RealmSwift

final class ProductsList: Object {
    @Persisted var products = List<Product>()
}

final class Product: Object {
    @Persisted var title = ""
    @Persisted var protein = 0.0
    @Persisted var fats = 0.0
    @Persisted var carbohydrates = 0.0
    @Persisted var calories = 0.0
}
