//
//  History.swift
//  MyCalories
//
//  Created by Иван Семикин on 08/04/2024.
//

import Foundation
import RealmSwift

final class UsedProductsList: Object {
    @Persisted var usedProducts = List<Product>()
}

final class History: Object {
    @Persisted var date = Date()
    @Persisted var productList = List<Product>()
    @Persisted var waterList = List<Water>()
}

final class Product: Object {
    @Persisted var name = ""
    @Persisted var protein = 0.0
    @Persisted var fats = 0.0
    @Persisted var carbohydrates = 0.0
    @Persisted var calories = 0.0
    @Persisted var date = Date()
    @Persisted var weight = 0.0
    @Persisted var index = 0
    @Persisted var color = "colorApp"
}

final class Water: Object {
    @Persisted var date = Date()
    @Persisted var ml = 0
}
