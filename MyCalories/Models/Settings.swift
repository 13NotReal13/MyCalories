//
//  Settings.swift
//  MyCalories
//
//  Created by Иван Семикин on 06/04/2024.
//

import RealmSwift

struct Settings {
    let caloriesEnabled: Bool
    let bguEnabled: Bool
    let waterEnabled: Bool
}

final class UserProgramm: Object {
    @Persisted var calories = 0
    @Persisted var proteins = 0
    @Persisted var fats = 0
    @Persisted var carbohydrates = 0
    @Persisted var water = 0
}
