//
//  AllProducts.swift
//  MyCalories
//
//  Created by Иван Семикин on 01/05/2024.
//

import Foundation
import RealmSwift

final class AllProducts: Object {
    @Persisted var productList = List<Product>()
}
