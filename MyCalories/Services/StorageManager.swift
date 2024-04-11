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
    
    private var projectRealmConfiguration: Realm.Configuration {
        let resourcesURL = Bundle.main.resourceURL!
        let realmFilename = "userProducts.realm"
        let realmFileURL = resourcesURL.appendingPathComponent(realmFilename)
        return Realm.Configuration(fileURL: realmFileURL)
    }
    
    private var deviceRealmConfiguration: Realm.Configuration {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let deviceRealmURL = documentsDirectoryURL.appendingPathComponent("default.realm")
        return Realm.Configuration(fileURL: deviceRealmURL)
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
    func fetchProductsFromProjectRealm(completion: @escaping((Results<Product>) -> Void)) {
        let realm = getProjectRealm()
        completion(realm.objects(Product.self))
    }
    
    func fetchUserProgrammFromDeviceRealm() -> UserProgramm {
        let realm = getDeviceRealm()
        var userProgramm = realm.objects(UserProgramm.self).first
        
        if userProgramm == nil {
            writeDeviceRealm {
                realm.add(UserProgramm())
            }
        }
        
        userProgramm = realm.objects(UserProgramm.self).first
        return userProgramm ?? UserProgramm()
    }
    
    func saveUserProgramm(nutrition: Nutrition, newValue: Int) {
        let userProgramm = fetchUserProgrammFromDeviceRealm()
        
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
    
    // Метод для получения базы данных Realm проекта
    private func getProjectRealm() -> Realm {
        let realm: Realm
        do {
            realm = try Realm(configuration: projectRealmConfiguration)
        } catch {
            fatalError("Failed to initialize Project Realm: \(error)")
        }
        
        return realm
    }
    
    // Метод для получения базы данных Realm на устройстве пользователя
    private func getDeviceRealm() -> Realm {
        let realm: Realm
        do {
            realm = try Realm(configuration: deviceRealmConfiguration)
        } catch {
            fatalError("Failed to initialize Device Realm: \(error)")
        }
        
        return realm
    }
    
    private func writeDeviceRealm(completion: () -> Void) {
        let realm = getDeviceRealm()
        do {
            try realm.write {
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
    //        let realmFileURL = resourcesURL.appendingPathComponent("userProducts.realm")
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
