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
//        print("Realm from project: \(realm.configuration.fileURL)")
        
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
    func fetchProductsFromProjectRealm(completion: @escaping((Results<Product>) -> Void)) {
        completion(realmProject.objects(Product.self))
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
    
    // Person
    func fetchPerson() -> Person? {
        realmDevice.objects(Person.self).first
    }
    
    func savePerson(_ person: Person) {
        writeDeviceRealm {
            if let existingPerson = fetchPerson() {
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
//        // Получаем путь к папке Resources внутри проекта
//        guard let resourcesURL = Bundle.main.resourceURL else {
//            print("Ошибка: не удалось найти папку Resources")
//            return
//        }
//        
//        // Определяем URL для файла базы данных в папке Resources
//        let realmFileURL = resourcesURL.appendingPathComponent("productsFromProject.realm")
//        
//        // Создаем объект Realm.Configuration с указанным путем к файлу базы данных
//        let config = Realm.Configuration(fileURL: realmFileURL)
//        
//        do {
//            // Пытаемся открыть Realm с использованием нашей конфигурации
//            let realm = try Realm(configuration: config)
//            // Realm успешно создан в папке Resources
//            print(realm.configuration.fileURL)
//            print("База данных Realm успешно создана в папке Resources")
//        } catch {
//            // В случае ошибки выводим сообщение об ошибке
//            print("Ошибка при создании базы данных Realm: \(error)")
//        }
//    }
}
