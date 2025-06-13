//
//  ProfileModalPickerView.swift
//  MyCalories
//
//  Created by Иван Семикин on 12/05/2025.
//

import SwiftUI

enum PickerModalDisplay: String, CaseIterable {
    case gender = "Пол:"
    case dateBirth = "Дата рождения:"
    case height = "Рост:"
    case weight = "Вес:"
    case activityLevel = "Ативность:"
    case goal = "Цель:"
}

struct ProfilePickerModalView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss

    // Временные локальные значения
    @State private var localGender: Gender = .male
    @State private var localDate: Date = Date()
    @State private var localHeight: Double = 170
    @State private var localWeight: (kg: Double, gr: Double) = (70, 0)
    @State private var localActivity: Activity = .medium
    @State private var localGoal: Goal = .maintainWeight

    var body: some View {
        VStack {
            Group {
                switch profileViewModel.selectedDisplay {
                case .gender:
                    Picker("Выберите пол:", selection: $localGender) {
                        ForEach(Gender.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }

                case .dateBirth:
                    DatePicker(
                        "Дата рождения:",
                        selection: $localDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.wheel)

                case .height:
                    Picker("Выберите рост:", selection: $localHeight) {
                        ForEach(20...300, id: \.self) { h in
                            Text("\(h) см").tag(Double(h))
                        }
                    }

                case .weight:
                    HStack {
                        Picker("Вес (кг):", selection: $localWeight.kg) {
                            ForEach(10...300, id: \.self) { kg in
                                Text("\(kg) кг.").tag(Double(kg))
                            }
                        }
                        Picker("Граммы:", selection: $localWeight.gr) {
                            ForEach(Array(stride(from: 0, to: 950, by: 50)), id: \.self) { g in
                                Text("\(g) гр.").tag(Double(g))
                            }
                        }
                    }

                case .activityLevel:
                    Picker("Активность:", selection: $localActivity) {
                        ForEach(Activity.allCases, id: \.self) {
                            Text($0.description).tag($0)
                        }
                    }

                case .goal:
                    Picker("Цель:", selection: $localGoal) {
                        ForEach(Goal.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                }
            }
            .customFont()
            .pickerStyle(.wheel)

            Button("Выбрать") {
                // Сохраняем локальные значения в @Binding
                switch profileViewModel.selectedDisplay {
                case .gender:
                    profileViewModel.gender = localGender
                case .dateBirth:
                    profileViewModel.dateOfBirthday = localDate
                case .height:
                    profileViewModel.height = localHeight
                case .weight:
                    profileViewModel.weight = localWeight
                case .activityLevel:
                    profileViewModel.activityLevel = localActivity
                case .goal:
                    profileViewModel.goal = localGoal
                }

                profileViewModel.hasUnsavedChanges = true
                dismiss()
            }
            .customFont(font: .bold, color: .white)
            .customCapsuleButton()
        }
        .onAppear {
            // Передаём начальные значения в локальные
            if let g = profileViewModel.gender { localGender = g }
            if let d = profileViewModel.dateOfBirthday { localDate = d }
            if let h = profileViewModel.height { localHeight = h }
            if let w = profileViewModel.weight { localWeight = w }
            if let a = profileViewModel.activityLevel { localActivity = a }
            if let go = profileViewModel.goal { localGoal = go }
        }
    }
}

extension PickerModalDisplay {
    var preferredDetent: PresentationDetent {
        switch self {
        case .gender:
            .fraction(0.2)
        case .dateBirth:
            .fraction(0.35)
        case .activityLevel:
                .fraction(0.25)
        case .goal:
                .fraction(0.25)
        default:
            .fraction(0.3)
        }
    }
}
