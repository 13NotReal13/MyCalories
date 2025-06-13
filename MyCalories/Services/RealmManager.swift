//
//  StorageManager.swift
//  MyCalories
//
//  Created by Иван Семикин on 14/05/2025.
//

import Foundation
import RealmSwift

final class RealmManager: ObservableObject {
    static let shared = RealmManager()
    private init() {}
    
    private var realmProject: Realm {
        let realmFileName = "productsFromProject.realm"
        let realmFileUrl = Bundle.main.resourceURL!.appendingPathComponent(realmFileName)
        var realmConfig = Realm.Configuration(fileURL: realmFileUrl, readOnly: true)
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
        
        return realm
    }
    
    func fetchAllProducts(completion: @escaping (Results<Product>) -> Void) {
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
            
            completion(realmDevice.objects(AllProducts.self).first!.productList.sorted(byKeyPath: "index"))
            return
        }
        
        completion(allProductsInDevice.productList.sorted(byKeyPath: "index"))
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
    
    func addProductToHistory(_ product: Product) {
        let productDate = Calendar.current.startOfDay(for: product.date)

        writeDeviceRealm {
            if let historyOfProducts = realmDevice.objects(History.self).filter("date == %@", productDate).first {
                historyOfProducts.productList.append(product)
            } else {
                let newHistoryOfProducts = History()
                newHistoryOfProducts.date = productDate
                newHistoryOfProducts.productList.append(product)
                realmDevice.add(newHistoryOfProducts)
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
}
