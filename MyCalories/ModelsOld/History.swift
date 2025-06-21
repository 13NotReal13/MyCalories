//
//  History.swift
//  MyCalories
//
//  Created by Иван Семикин on 08/04/2024.
//

import Foundation
import RealmSwift

final class History: Object {
    @Persisted var date = Date()
    @Persisted var productList = List<Product>()
    @Persisted var waterList = List<Water>()
}

final class Product: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
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

extension Product {
    var proteinToString: String {
        "\(String(format: "%.2f", protein))"
    }
    var fatsToString: String {
        "\(String(format: "%.2f", fats))"
    }
    var carbohydratesToString: String {
        "\(String(format: "%.2f", carbohydrates))"
    }
    var caloriesToString: String {
        "\(String(format: "%.2f", calories))"
    }
    
    func formattedBy(weight: Int, for value: Double) -> String {
        let result = value * Double(weight) / 100.0
        return String(format: "%.1f", result)
    }
}

final class Water: Object {
    @Persisted var date = Date()
    @Persisted var ml = 0
}

// fake data for prewiew
extension Product {
    static func fake(name: String) -> Product {
        let product = Product()
        product.name = name
        product.protein = 12.5
        product.fats = 8.0
        product.carbohydrates = 20.0
        product.calories = 250
        product.date = Date()
        product.weight = 100
        product.index = 0
        product.color = "colorApp"
        
        return product
    }
}
