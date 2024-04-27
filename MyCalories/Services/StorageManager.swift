//
//  UserDefaults.swift
//  MyCalories
//
//  Created by Иван Семикин on 06/04/2024.
//

import Foundation
import RealmSwift

enum Nutrition {
    case calories
    case proteins
    case fats
    case carbohydrates
    case water
}

final class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let caloriesKey = "caloriesEnabled"
    private let bguKey = "bguEnabled"
    private let waterKey = "waterEnabled"
    
    private var realmProject: Realm {
        let resourcesURL = Bundle.main.resourceURL!
        let realmFilename = "productsFromProject.realm"
        let realmFileURL = resourcesURL.appendingPathComponent(realmFilename)
        let realmConfig = Realm.Configuration(fileURL: realmFileURL, readOnly: true)
        
        let realm: Realm
        do {
            realm = try Realm(configuration: realmConfig)
        } catch {
            fatalError("Failed to initialize Project Realm: \(error)")
        }
        
        return realm
    }
    
    private var realmDevice: Realm {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let deviceRealmURL = documentsDirectoryURL.appendingPathComponent("default.realm")
        let realmConfig = Realm.Configuration(fileURL: deviceRealmURL)
        
        let realm: Realm
        do {
            realm = try Realm(configuration: realmConfig)
        } catch {
            fatalError("Failed to initialize Device Realm: \(error)")
        }
//        print("Realm from user: \(realm.configuration.fileURL)")
        
        return realm
    }
    
    private init() {}
    
    //  MARK: - UserDefaults
    func fetchSettings() -> Settings {
        userDefaults.register(defaults: [caloriesKey: true, bguKey: true, waterKey: true])
        
        let caloriesEnabled = userDefaults.bool(forKey: caloriesKey)
        let bguEnabled = userDefaults.bool(forKey: bguKey)
        let waterEnabled = userDefaults.bool(forKey: waterKey)
        
        return Settings(
            caloriesEnabled: caloriesEnabled,
            bguEnabled: bguEnabled,
            waterEnabled: waterEnabled
        )
    }
    
    func saveSettings(_ settings: Settings) {
        userDefaults.setValue(settings.caloriesEnabled, forKey: caloriesKey)
        userDefaults.setValue(settings.bguEnabled, forKey: bguKey)
        userDefaults.setValue(settings.waterEnabled, forKey: waterKey)
    }
    
    // MARK: - Realm
    // User Programm
    func fetchProjectProducts(completion: @escaping([Product]) -> Void) {
        let products = realmProject.objects(Product.self)
        completion(Array(products))
    }
    
    func fetchUserProgramm() -> UserProgramm {
        var userProgramm = realmDevice.objects(UserProgramm.self).first
        
        if userProgramm == nil {
            writeDeviceRealm {
                realmDevice.add(UserProgramm())
            }
        }
        
        userProgramm = realmDevice.objects(UserProgramm.self).first
        return userProgramm ?? UserProgramm()
    }
    
    func saveUserProgramm(nutrition: Nutrition, newValue: Int) {
        let userProgramm = fetchUserProgramm()
        
        writeDeviceRealm {
            switch nutrition {
            case .calories:
                userProgramm.calories = newValue
            case .proteins:
                userProgramm.proteins = newValue
            case .fats:
                userProgramm.fats = newValue
            case .carbohydrates:
                userProgramm.carbohydrates = newValue
            case .water:
                userProgramm.water = newValue
            }
        }
    }
    
    // RecommendedProgramm
    func fetchRecommendedProgramm() -> RecommendedProgramm? {
        return realmDevice.objects(RecommendedProgramm.self).first
    }
    
    func saveRecommendedProgramm(_ programm: RecommendedProgramm) {
        writeDeviceRealm {
            if let existingRecommendedProgramm = fetchRecommendedProgramm() {
                existingRecommendedProgramm.proteins = programm.proteins
                existingRecommendedProgramm.fats = programm.fats
                existingRecommendedProgramm.carbohydrates = programm.carbohydrates
                existingRecommendedProgramm.calories = programm.calories
                existingRecommendedProgramm.water = programm.water
            } else {
                realmDevice.add(programm)
            }
        }
    }
    
    // Person
    func fetchPerson() -> Person? {
        realmDevice.objects(Person.self).first
    }
    
    func savePerson(_ person: Person) {
        writeDeviceRealm {
            if let existingPerson = fetchPerson() {
                existingPerson.gender = person.gender
                existingPerson.dateOfBirthday = person.dateOfBirthday
                existingPerson.height = person.height
                existingPerson.weight = person.weight
                existingPerson.activity = person.activity
                existingPerson.goal = person.goal
            } else {
                realmDevice.add(person)
            }
        }
    }
    
    // Used Products
    func fetchUsedProducts(completion: @escaping([Product]) -> Void) {
        let products = realmDevice.objects(UsedProductsList.self).first?.usedProducts ?? List<Product>()
        completion(Array(products))
    }

    func fetchHistoryOfProducts(completion: @escaping(Results<HistoryOfProducts>) -> Void) {
        completion(realmDevice.objects(HistoryOfProducts.self))
    }
    
    func saveNewProductToUsedProducts(_ product: Product) {
        let productForAdd = Product(value:
                                        [
                                            product.name,
                                            product.protein,
                                            product.fats,
                                            product.carbohydrates,
                                            product.calories
                                        ]
                                    )
        
        writeDeviceRealm {
            if let usedProductsList = realmDevice.objects(UsedProductsList.self).first {
                if !usedProductsList.usedProducts.contains(where: { $0.name == productForAdd.name }) {
                    usedProductsList.usedProducts.append(productForAdd)
                }
            } else {
                let newUsedProductsList = UsedProductsList()
                newUsedProductsList.usedProducts.append(productForAdd)
                realmDevice.add(newUsedProductsList)
            }
        }
    }
    
    func saveProductToHistory(_ product: Product) {
        let productDate = Calendar.current.startOfDay(for: product.date)

        writeDeviceRealm {
            if let historyOfProducts = realmDevice.objects(HistoryOfProducts.self).filter("date == %@", productDate).first {
                historyOfProducts.usedProducts.append(product)
            } else {
                let newHistoryOfProducts = HistoryOfProducts()
                newHistoryOfProducts.date = productDate
                newHistoryOfProducts.usedProducts.append(product)
                realmDevice.add(newHistoryOfProducts)
            }
        }
    }
    
    func fetchTodayTotalNutrients() -> AllNutritions {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let todaysProducts = realmDevice.objects(HistoryOfProducts.self).filter("date >= %@ AND date < %@", startOfDay, endOfDay)
        
        var totalProtein = 0
        var totalFats = 0
        var totalCarbohydrates = 0
        var totalCalories = 0
        var totalWater = 0
        
        // Перебираем все записи за сегодня и суммируем значения
        for historyEntry in todaysProducts {
            for product in historyEntry.usedProducts {
                totalProtein += Int(product.protein)
                totalFats += Int(product.fats)
                totalCarbohydrates += Int(product.carbohydrates)
                totalCalories += Int(product.calories)
            }
        }
        
        let todaysWater = realmDevice.objects(HistoryOfWater.self).filter("date >= %@ AND date < %@", startOfDay, endOfDay)
        
        for historyEntry in todaysWater {
            for water in historyEntry.waterList {
                totalWater += water.ml
            }
        }
        
        return AllNutritions(
            proteins: totalProtein,
            fats: totalFats,
            carbohydrates: totalCarbohydrates,
            calories: totalCalories,
            water: totalWater
        )
    }

    // Used Water
    func fetchWaterList(completion: @escaping(Results<HistoryOfWater>) -> Void) {
        completion(realmDevice.objects(HistoryOfWater.self))
    }
    
    func saveWaterToHistory(_ water: Water, completion: @escaping() -> Void) {
        let waterDate = Calendar.current.startOfDay(for: water.date)
        
        writeDeviceRealm {
            if let historyOfWater = realmDevice.objects(HistoryOfWater.self).filter("date == %@", waterDate).first {
                historyOfWater.waterList.append(water)
            } else {
                let newHistoryOFWater = HistoryOfWater()
                newHistoryOFWater.date = waterDate
                newHistoryOFWater.waterList.append(water)
                realmDevice.add(newHistoryOFWater)
            }
        }
        
        completion()
    }
    
    private func writeDeviceRealm(completion: () -> Void) {
        do {
            try realmDevice.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
    
//    func createRealmDatabaseInResourcesFolder() {
//        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let deviceRealmURL = documentsDirectoryURL.appendingPathComponent("productsFromProject.realm")
//        let realmConfig = Realm.Configuration(fileURL: deviceRealmURL)
//        
//        let realm: Realm
//        do {
//            realm = try Realm(configuration: realmConfig)
//        } catch {
//            fatalError("Failed to initialize Device Realm: \(error)")
//        }
//    }
}
