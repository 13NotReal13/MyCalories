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
    @EnvironmentObject private var coordinator: NavigationCoordinator
    let display: PickerModalDisplay
    
    @State private var gender: Gender = .male
    @State private var dateBirth: Date = Date()
    @State private var height: Double = 170
    @State private var weight: (kg: Double, gramm: Double) = (0, 0)
    @State private var activityLevel: Activity = .low
    @State private var goal: Goal = .downWeight
    
    var body: some View {
        VStack {
            Group {
                switch display {
                    
                case .gender:
                    Picker("Выберите пол:", selection: $gender) {
                        Text(Gender.male.rawValue).tag(Gender.male)
                        Text(Gender.female.rawValue).tag(Gender.female)
                    }
                    
                case .dateBirth:
                    DatePicker(
                        "Дата рождения:",
                        selection: $dateBirth,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    
                case .height:
                    Picker("Выберите рост:", selection: $height) {
                        ForEach(20...300, id: \.self) { height in
                            Text("\(height) см.").tag(Double(height))
                        }
                    }
                    
                case .weight:
                    HStack {
                        Picker("Выерите текущий вес:", selection: $weight.kg) {
                            ForEach(10...300, id: \.self) { kg in
                                Text("\(kg) кг.").tag(weight.kg)
                            }
                        }
                        
                        Picker("Выерите текущий вес:", selection: $weight.gramm) {
                            ForEach(Array(stride(from: 0, to: 950, by: 50)), id: \.self) { kg in
                                Text("\(kg) гр.").tag(weight.gramm)
                            }
                        }
                    }
                    
                case .activityLevel:
                    Picker("Выберите активность", selection: $activityLevel) {
                        ForEach(Activity.allCases, id: \.rawValue) { activity in
                            Text(activity.description).tag(activity)
                        }
                    }
                    
                case .goal:
                    Picker("Выберите цель:", selection: $goal) {
                        ForEach(Goal.allCases, id: \.rawValue) { goal in
                            Text(goal.rawValue).tag(goal)
                        }
                    }
                }
            }
            .customFont()
            .pickerStyle(.wheel)
            
            Button {
                coordinator.dismissModal()
            } label: {
                Text("Выбрать")
                    .customFont(font: .bold, color: .white)
                    .padding()
                    .frame(width: 150)
                    .background {
                        Capsule()
                            .foregroundStyle(.colorApp)
                    }
            }
        }
    }
}

#Preview {
    ProfilePickerModalView(display: PickerModalDisplay.goal)
        .environmentObject(NavigationCoordinator.shared)
}
