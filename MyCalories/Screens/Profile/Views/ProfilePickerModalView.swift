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
    case activityLevel = "Уровень активности:"
    case goal = "Цель:"
}

struct ProfilePickerModalView: View {
    @Environment(\.dismiss) var dismiss
    let display: PickerModalDisplay

    @Binding var gender: Gender?
    @Binding var dateBirth: Date?
    @Binding var height: Double?
    @Binding var weight: (kg: Double, gr: Double)?
    @Binding var activityLevel: Activity?
    @Binding var goal: Goal?

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
                switch display {
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
                switch display {
                case .gender:
                    gender = localGender
                case .dateBirth:
                    dateBirth = localDate
                case .height:
                    height = localHeight
                case .weight:
                    weight = localWeight
                case .activityLevel:
                    activityLevel = localActivity
                case .goal:
                    goal = localGoal
                }

                dismiss()
            }
            .customFont(font: .bold, color: .white)
            .padding(.vertical, 12)
            .frame(width: 150)
            .background(Capsule().foregroundStyle(.colorApp))
        }
        .onAppear {
            // Передаём начальные значения в локальные
            if let g = gender { localGender = g }
            if let d = dateBirth { localDate = d }
            if let h = height { localHeight = h }
            if let w = weight { localWeight = w }
            if let a = activityLevel { localActivity = a }
            if let go = goal { localGoal = go }
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
