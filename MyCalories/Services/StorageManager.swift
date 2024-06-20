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
        var realmConfig = Realm.Configuration(fileURL: realmFileURL, readOnly: true)
        // Версия файла базы данных
        realmConfig.schemaVersion = 1
        
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
        // Можно создавать базу данных с любыим другим именем, если нужна новая
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
    
    func saveFirstOpenDate() {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "dateFirstOpen") == nil {
            userDefaults.set(Date(), forKey: "dateFirstOpen")
        }
    }
    
    func shouldShowAds() -> Bool {
        if let dateFirstOpen = userDefaults.object(forKey: "dateFirstOpen") as? Date {
            let hoursSinceFirstOpen = Date().timeIntervalSince(dateFirstOpen) / 3600
            return hoursSinceFirstOpen >= 48
        }
        return false
    }
    
    func saveLastAdShownDate() {
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: "lastAdShown")
        UserDefaults.standard.synchronize()
    }
    
    func isFifteenMinutesPassedSinceLastAd() -> Bool {
        if let lastAdShown = userDefaults.object(forKey: "lastAdShown") as? Date {
            let thirtyMinutes = 15 * 60 // 15 minutes in seconds
            return Date().timeIntervalSince(lastAdShown) >= TimeInterval(thirtyMinutes)
        }
        return true // Если реклама не показывалась, можно показать снова
    }
    
    func didAskedForScanBarcode() -> Bool {
        if let didAsked = userDefaults.object(forKey: "didAskedForScanBarcode") as? Bool {
            return didAsked
        }
        userDefaults.setValue(true, forKey: "didAskedForScanBarcode")
        return false
    }
    
    // MARK: - Realm
    // All Products
    func fetchAllProductsRu(completion: @escaping ([Product]) -> Void) {
        guard let allProductsInDevice = realmDevice.objects(AllProducts.self).first else {
            let productsFromProject = realmProject.objects(Product.self)
            
            writeDeviceRealm {
                let allProductsInDevice = AllProducts()
                var allProductsInProject: [Product] = []
                allProductsInProject.append(contentsOf: productsFromProject.map { projectProduct in
                    let newProduct = Product()
                    newProduct.name = projectProduct.name
                    newProduct.protein = projectProduct.protein
                    newProduct.fats = projectProduct.fats
                    newProduct.carbohydrates = projectProduct.carbohydrates
                    newProduct.calories = projectProduct.calories
                    newProduct.date = projectProduct.date
                    newProduct.weight = projectProduct.weight
                    newProduct.index = projectProduct.index
                    newProduct.color = projectProduct.color
                    return newProduct
                })
                
                allProductsInDevice.productList.append(objectsIn: allProductsInProject)
                realmDevice.add(allProductsInDevice)
            }
            
            completion(Array(realmDevice.objects(Product.self).sorted(byKeyPath: "index")))
            return
        }
        
        completion(Array(allProductsInDevice.productList.sorted(byKeyPath: "index")))
    }
    
    func fetchAllProductsEn(completion: @escaping ([Product]) -> Void) {
        guard let allProductsInDevice = realmDevice.objects(AllProducts.self).first else {
            let urlString = "https://world.openfoodfacts.org/category/vegetables.json?fields=product_name,nutriments&page_size=100"
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                completion([])
                return
            }
            
            URLSession.shared.dataTask(with: url) { [unowned self] data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                    DispatchQueue.main.async {
                        completion([])
                    }
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(ProductsResponse.self, from: data)
                    var index = 1
                    let productsFromApi = response.products.compactMap { apiProduct -> Product? in
                        guard let name = apiProduct.productName, !name.isEmpty else { return nil }
                        let product = createProductFrom(apiProduct: apiProduct, index: index)
                        index += 1
                        return product
                    }
                    
                    var uniqueProducts = [String: Product]()
                    for product in productsFromApi {
                        // Проверка на уникальность и более полную информацию
                        if let existing = uniqueProducts[product.name.lowercased()], (existing.protein) < (product.protein) {
                            uniqueProducts[product.name.lowercased()] = product
                        } else if uniqueProducts[product.name.lowercased()] == nil {
                            uniqueProducts[product.name.lowercased()] = product
                        }
                    }

                    // Отфильтровываем продукты, строго соответствующие поиску
                    let filteredUniqueProducts = uniqueProducts.values.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                    
                    self.writeDeviceRealm {
                        let allProductsInDevice = AllProducts()
                        allProductsInDevice.productList.append(objectsIn: filteredUniqueProducts)
                        self.realmDevice.add(allProductsInDevice)
                    }
                    
                    DispatchQueue.main.async {
                        let sortedProducts = Array(self.realmDevice.objects(Product.self).sorted(byKeyPath: "index"))
                        DispatchQueue.main.async {
                            completion(sortedProducts)
                        }
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            }.resume()
            return
        }
        
        let sortedProducts = Array(allProductsInDevice.productList.sorted(byKeyPath: "index"))
        DispatchQueue.main.async {
            completion(sortedProducts)
        }
    }
    
    func createProductFrom(apiProduct: FoundProduct, index: Int) -> Product {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        let product = Product()
        product.name = apiProduct.productName ?? "Unknown"
        product.protein = Double(formatter.string(for: apiProduct.nutriments.proteins) ?? "0.0") ?? 0.0
        product.fats = Double(formatter.string(for: apiProduct.nutriments.fat) ?? "0.0") ?? 0.0
        product.carbohydrates = Double(formatter.string(for: apiProduct.nutriments.carbohydrates) ?? "0.0") ?? 0.0
        product.calories = Double(formatter.string(for: apiProduct.nutriments.energyKcal) ?? "0.0") ?? 0.0
        product.index = index
        product.color = "black"

        return product
    }
    
    // User Programm
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
    
    // History
    func fetchHistory(completion: @escaping(Results<History>) -> Void) {
        completion(realmDevice.objects(History.self).sorted(byKeyPath: "date", ascending: false))
    }
    
    func saveOriginalAndAdjustedProduct(original: Product, adjusted: Product, completion: @escaping () -> Void) {
        writeDeviceRealm {
            // Add to Base if it isn't there
            let products = realmDevice.objects(Product.self).sorted(byKeyPath: "index", ascending: true)
            
            for productFromBase in products {
                productFromBase.index += 1
            }
            
            let allProducts = realmDevice.objects(AllProducts.self).first ?? {
                let newAllProducts = AllProducts()
                realmDevice.add(newAllProducts)
                return newAllProducts
            }()
            
            if !allProducts.productList.contains(where: { $0.name == original.name }) {
                original.index = 0
                original.color = "colorApp"
                allProducts.productList.append(original)
            } else {
                original.index = 0
                original.color = "colorApp"
            }
            
            // Add to History
            let productDate = Calendar.current.startOfDay(for: adjusted.date)
            if let historyOfProducts = realmDevice.objects(History.self).filter("date == %@", productDate).first {
                historyOfProducts.productList.append(adjusted)
            } else {
                let newHistoryOfProducts = History()
                newHistoryOfProducts.date = productDate
                newHistoryOfProducts.productList.append(adjusted)
                realmDevice.add(newHistoryOfProducts)
            }
            
            completion()
        }
    }
    
    // Add new product to base
    func addNewProductToBase(_ product: Product, completion: @escaping() -> Void) {
        writeDeviceRealm {
            let products = realmDevice.objects(Product.self).sorted(byKeyPath: "index", ascending: true)
            
            for productFromBase in products {
                productFromBase.index += 1
            }
            
            if let allProducts = realmDevice.objects(AllProducts.self).first {
                product.index = 0
                allProducts.productList.append(product)
                realmDevice.add(product)
            }
            completion()
        }
    }
    
    func editProductFromHistory(_ product: Product, withNewWeight weight: Double, completion: @escaping() -> Void) {
        writeDeviceRealm {
            let percent = weight / product.weight
            
            product.protein *= percent
            product.fats *= percent
            product.carbohydrates *= percent
            product.calories *= percent
            product.weight = weight
            
            completion()
        }
    }
    
    func fetchTodayTotalNutrients() -> AllNutritions {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let history = realmDevice.objects(History.self).filter("date >= %@ AND date < %@", startOfDay, endOfDay)
        
        var totalProtein = 0
        var totalFats = 0
        var totalCarbohydrates = 0
        var totalCalories = 0
        var totalWater = 0
        
        // Перебираем все записи за сегодня и суммируем значения
        for historyEntry in history {
            for product in historyEntry.productList {
                totalProtein += Int(product.protein)
                totalFats += Int(product.fats)
                totalCarbohydrates += Int(product.carbohydrates)
                totalCalories += Int(product.calories)
            }
        }
        
        for historyEntry in history {
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
    
    // Delete product from base
    func deleteProduct(_ product: Product, completion: @escaping() -> Void) {
        writeDeviceRealm {
            realmDevice.delete(product)
            completion()
        }
    }
    
    // Used Water
    func saveWaterToHistory(_ water: Water, completion: @escaping() -> Void) {
        let waterDate = Calendar.current.startOfDay(for: water.date)
        
        writeDeviceRealm {
            if let historyOfWater = realmDevice.objects(History.self).filter("date == %@", waterDate).first {
                historyOfWater.waterList.append(water)
            } else {
                let newHistoryOFWater = History()
                newHistoryOFWater.date = waterDate
                newHistoryOFWater.waterList.append(water)
                realmDevice.add(newHistoryOFWater)
            }
        }
        
        completion()
    }
    
    func editWaterFromHistory(_ water: Water, withNewML ml: Int, completion: @escaping() -> Void) {
        writeDeviceRealm {
            water.ml = ml
            completion()
        }
    }
    
    
    // Delete water/product from history
    func deleteItemFromHistory<T: RealmFetchable>(_ item: T, history: History) {
        writeDeviceRealm {
            if let product = item as? Product {
                if history.productList.count == 1 && history.waterList.isEmpty {
                    realmDevice.delete(product)
                    realmDevice.delete(history)
                } else {
                    realmDevice.delete(product)
                }
            } else if let water = item as? Water {
                if history.waterList.count == 1 && history.productList.isEmpty {
                    realmDevice.delete(water)
                    realmDevice.delete(history)
                } else {
                    realmDevice.delete(water)
                }
            }
        }
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
    
//    func createRealmDatabaseWithOnlyProduct() {
//        // Получаем путь к папке Documents
//        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            fatalError("Documents directory is unavailable")
//        }
//        
//        func createRealmDatabaseInResourcesFolder() {
//            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let deviceRealmURL = documentsDirectoryURL.appendingPathComponent("productsFromProject.realm")
//            let realmConfig = Realm.Configuration(fileURL: deviceRealmURL)
//            
//            let realm: Realm
//            do {
//                realm = try Realm(configuration: realmConfig)
//            } catch {
//                fatalError("Failed to initialize Device Realm: \(error)")
//            }
//            print("Realm from user: \(realm.configuration.fileURL)")
//        }
//    }
}
