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
    var proteins: Double?
    var fat: Double?
    var carbohydrates: Double?
    var energyKcal: Double?

    enum CodingKeys: String, CodingKey {
        case proteins = "proteins_100g"
        case fat = "fat_100g"
        case carbohydrates = "carbohydrates_100g"
        case energyKcal = "energy-kcal_100g"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        proteins = try container.decodeDoubleOrString(forKey: .proteins)
        fat = try container.decodeDoubleOrString(forKey: .fat)
        carbohydrates = try container.decodeDoubleOrString(forKey: .carbohydrates)
        energyKcal = try container.decodeDoubleOrString(forKey: .energyKcal)
    }
}

extension KeyedDecodingContainer {
    func decodeDoubleOrString(forKey key: Key) throws -> Double? {
        if let value = try? decode(Double.self, forKey: key) {
            return value
        }
        if let stringValue = try? decode(String.self, forKey: key), let value = Double(stringValue) {
            return value
        }
        return nil
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
