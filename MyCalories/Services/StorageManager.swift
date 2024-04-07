//
//  UserDefaults.swift
//  MyCalories
//
//  Created by Иван Семикин on 06/04/2024.
//

import Foundation

final class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let caloriesKey = "caloriesEnabled"
    private let bguKey = "bguEnabled"
    private let waterKey = "waterEnabled"
    
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
    
    func fetchUserProgramm() -> UserProgramm {
        UserProgramm(
            calories: 2480,
            proteins: 220,
            fats: 129,
            carbohydrates: 310,
            water: 1980
        )
    }
    
    func saveUserProgramm(_ programm: UserProgramm) {
        
    }
}
