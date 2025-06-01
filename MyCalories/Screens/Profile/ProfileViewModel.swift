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
    static let shared = ProfileViewModel()
    
    @Published var person: Person?
    
    @Published var gender: Gender?
    @Published var dateOfBirthday: Date?
    @Published var height: Double?
    @Published var weight: (kg: Double, gr: Double)?
    @Published var activityLevel: Activity?
    @Published var goal: Goal?
    
    @Published var isPresentingPicker = false
    @Published var selectedDisplay: PickerModalDisplay = .gender
    
    var saveButtonIsEnabled: Bool {
        gender != nil
        && dateOfBirthday != nil
        && height != nil
        && weight != nil
        && activityLevel != nil
        && goal != nil
    }
    
    init() {}
    
    func setValue(for item: PickerModalDisplay) -> String {
        switch item {
        case .gender:
            return gender?.rawValue ?? "выбрать"
        case .dateBirth:
            guard let dateOfBirthday else { return "выбрать" }
            return DateFormatter.localizedString(from: dateOfBirthday, dateStyle: .medium, timeStyle: .none)
        case .height:
            guard let height else { return "выбрать" }
            return "\(Int(height)) см."
        case .weight:
            guard let weight else { return "выбрать" }
            return "\(Int(weight.kg)) кг. \(Int(weight.gr)) гр."
        case .activityLevel:
            return activityLevel?.rawValue ?? "выбрать"
        case .goal:
            return goal?.rawValue ?? "выбрать"
        }
    }
    
    func savePersonData() {
    
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
