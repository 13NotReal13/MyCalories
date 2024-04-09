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
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let projectRealmURL = documentsDirectoryURL.appendingPathComponent("userProducts.realm")
        return Realm.Configuration(fileURL: projectRealmURL)
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
    // Метод для получения пути к базе данных Realm на устройстве пользователя
    private func getDeviceRealmURL() -> URL {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectoryURL.appendingPathComponent("default.realm")
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
    
    private func writeProjectRealm(completion: () -> Void) {
        let realm = getProjectRealm()
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
}
