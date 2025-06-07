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
    private let realmManager: RealmManager
    
    // Person Data
    @Published var person: Person?
    
    @Published var gender: Gender?
    @Published var dateOfBirthday: Date?
    @Published var height: Double?
    @Published var weight: (kg: Double, gr: Double)?
    @Published var activityLevel: Activity?
    @Published var goal: Goal?
    
    @Published var hasUnsavedChanges = false
    
    // Picker modal
    @Published var isPresentingPicker = false
    @Published var selectedDisplay: PickerModalDisplay = .gender
    
    // Recommended programm data
    @Published var recommendedProgramm: RecommendedProgramm?
    
    var saveButtonIsEnabled: Bool {
        gender != nil
        && dateOfBirthday != nil
        && height != nil
        && weight != nil
        && activityLevel != nil
        && goal != nil
        && hasUnsavedChanges
    }
    
    init(realmManager: RealmManager) {
        self.realmManager = realmManager
        
        fetchPerson()
        fetchRecommendedProgramm()
    }
    
    func savePersonData() {
        guard let gender, let dateOfBirthday, let height, let weight, let activityLevel, let goal else {
            return
        }
        
        let newPersonData = Person()
        
        newPersonData.gender = gender == .male ? Gender.male.rawValue : Gender.female.rawValue
        newPersonData.dateOfBirthday = dateOfBirthday
        newPersonData.height = height
        newPersonData.weight = weight.kg + weight.gr
        
        switch activityLevel {
            case .low:
            newPersonData.activity = Activity.low.rawValue
        case .medium:
            newPersonData.activity = Activity.medium.rawValue
        default:
            newPersonData.activity = Activity.high.rawValue
        }
        
        switch goal {
        case .downWeight:
            newPersonData.goal = Goal.downWeight.rawValue
        case .maintainWeight:
            newPersonData.goal = Goal.maintainWeight.rawValue
        default:
            newPersonData.goal = Goal.upWeight.rawValue
        }
        
        realmManager.savePerson(newPersonData)
        calculateRecommendedProgramm()
        hasUnsavedChanges = false
    }
    
    func calculateRecommendedProgramm() {
        guard let person else { return }
        let personAge = Date.getAge(fromDate: person.dateOfBirthday)
        
        var protein: Double
        var fats: Double
        var carbohydrates: Double
        var calories: Double
        var water: Double
        
        calories = person.gender == "Мужчина"
            ? (person.weight * 10.0) + (person.height * 6.25) - (personAge * 5) + 5
            : (person.weight * 10.0) + (person.height * 6.25) - (personAge * 5) - 161
        
        water = person.gender == "Мужчина" ? person.weight * 30 : person.weight * 25
        
        switch person.activity {
        case "Низкая":
            calories *= 1.2
            water += person.gender == "Мужчина" ? (0.57 * 500) : (0.57 * 400)
        case "Средняя":
            calories *= 1.4
            water += person.gender == "Мужчина" ? (1.42 * 500) : (1.42 * 400)
        default:
            calories *= 1.8
            water += person.gender == "Мужчина" ? (2.0 * 500) : (2.0 * 400)
        }
        
        switch person.goal {
        case "Снизить вес":
            calories *= 0.8
            protein = calories * 0.5 / 4
            fats = calories * 0.2 / 9
            carbohydrates = calories * 0.3 / 4
        case "Удержать вес":
            protein = calories * 0.3 / 4
            fats = calories * 0.3 / 9
            carbohydrates = calories * 0.4 / 4
        default:
            calories *= 1.25
            protein = calories * 0.3 / 4
            fats = calories * 0.2 / 9
            carbohydrates = calories * 0.5 / 4
        }
        
        let recommendedProgramm = RecommendedProgramm(
            value: [
                Int(protein),
                Int(fats),
                Int(carbohydrates),
                Int(calories),
                Int(water)
            ]
        )
        
        self.recommendedProgramm = recommendedProgramm
        realmManager.saveRecommendedProgramm(recommendedProgramm)
    }
    
    func setPersonDataValues(for item: PickerModalDisplay) -> String {
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
    
    private func fetchPerson() {
        guard let person = realmManager.fetchPerson() else { return }
        self.person = person

        gender = person.gender == "Мужской" ? .male : .female
        dateOfBirthday = person.dateOfBirthday
        height = person.height
        
        let kg = floor(person.weight)
        let gr = (person.weight - kg) * 1000
        weight = (kg, gr)
        
        switch person.activity {
        case "Низкий":
            activityLevel = .low
        case "Средний":
            activityLevel = .medium
        default:
            activityLevel = .high
        }
        
        switch person.goal {
        case "Снизить вес":
            goal = .downWeight
        case "Удержать вес":
            goal = .maintainWeight
        default:
            goal = .upWeight
        }
    }
    
    private func fetchRecommendedProgramm() {
        guard let recommendedValues = realmManager.fetchRecommendedProgramm() else { return }
        recommendedProgramm = recommendedValues
    }
}
