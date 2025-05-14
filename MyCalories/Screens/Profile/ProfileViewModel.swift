//
//  ProfileViewModel.swift
//  MyCalories
//
//  Created by Иван Семикин on 11/05/2025.
//

import Foundation

enum Gender: String, CaseIterable, Identifiable {
    case male = "Мужской"
    case female = "Женский"
    
    var id: Self { self }
}

enum Activity: String, CaseIterable {
    case low = "Низкая"
    case medium = "Средняя"
    case high = "Высокая"
    
    var description: String {
        switch self {
        case .low:
            "Низкая (сидячий образ жизни)"
        case .medium:
            "Средняя (лёгкие физ. нагрузки)"
        case .high:
            "Высокая (тяжёлые физ. нагрузки)"
        }
    }
}

enum Goal: String, CaseIterable {
    case downWeight = "Снизить вес"
    case maintainWeight = "Удержать вес"
    case upWeight = "Набрать вес"
}

final class ProfileViewModel: ObservableObject {
//    @Published var person: Person?
    
    @Published var gender: Gender = .male
    @Published var dateOfBirthday: Date = .now
    @Published var dateOfBirthdayText = "выбрать дату"
    @Published var height: Double = 0.0
    @Published var weight: Double = 0.0
    @Published var activity: String = Activity.medium.rawValue
    @Published var goal: String = Goal.maintainWeight.rawValue
    
    static let shared = ProfileViewModel()
    
    init() {
    }
    
    private func fetchPerson() {
//        guard let person = StorageManager.shared.fetchPerson() else { return }
//        self.person = person
//        
//        genderSegmentedControl = person.gender == "Мужской" ? .male : .female
//        dateOfBirthday = person.dateOfBirthday
//        height = person.height
//        weight = person.weight
//        activity = person.activity
//        goal = person.goal
    }
}
