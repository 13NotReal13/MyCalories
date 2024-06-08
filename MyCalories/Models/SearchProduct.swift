//
//  SearchProduct.swift
//  MyCalories
//
//  Created by Иван Семикин on 31/05/2024.
//
import Foundation

struct SearchProduct: Codable {
    let product: FoundProduct?
    let errors: [ErrorItem]?
    let result: ResultStatus?
}

struct FoundProduct: Codable {
    let productName: String?
    let nutriments: Nutriments

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case nutriments
    }
}

struct Nutriments: Codable {
    let proteins: Double?
    let fat: Double?
    let carbohydrates: Double?
    let energyKcal: Double?

    enum CodingKeys: String, CodingKey {
        case proteins = "proteins_100g"
        case fat = "fat_100g"
        case carbohydrates = "carbohydrates_100g"
        case energyKcal = "energy-kcal_100g"
    }
}

struct ErrorItem: Codable {
    let message: ErrorMessage
}

struct ErrorMessage: Codable {
    let id: String
}

struct ResultStatus: Codable {
    let id: String
}
