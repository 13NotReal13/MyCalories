//
//  RecommendedProgrammView.swift
//  MyCalories
//
//  Created by Иван Семикин on 01/06/2025.
//

import SwiftUI

struct RecommendedProgrammView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    private var titleRecommendation: String {
        switch profileViewModel.goal {
        case .downWeight:
            return " для снижения веса"
        case .maintainWeight:
            return " для поддержания веса"
        case .upWeight:
            return " для набора массы"
        case .none:
            return ""
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Ежедневная рекомендуемая норма\(titleRecommendation):")
                .customFont()
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                NutritionRowView(
                    title: "Белки:",
                    value: profileViewModel.protein,
                    unit: "гр."
                )
                NutritionRowView(
                    title: "Жиры:",
                    value: profileViewModel.fats,
                    unit: "гр."
                )
                NutritionRowView(
                    title: "Углеводы:",
                    value: profileViewModel.carbohydrates,
                    unit: "гр."
                )
                NutritionRowView(
                    title: "Калории:",
                    value: profileViewModel.calories,
                    unit: "ккал"
                )
                NutritionRowView(
                    title: "Вода:",
                    value: profileViewModel.water,
                    unit: "мл"
                )
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.2), radius: 8)
            }
            
            Button {
                if let url = URL(string: "https://en.m.wikipedia.org/wiki/Basal_metabolic_rate") {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Источник расчёта формул")
                    .customFont(size: 13, color: .blue)
            }
        }
        .padding([.horizontal, .bottom], 16)
        .padding(.vertical)
    }
}

struct NutritionRowView: View {
    let title: String
    let value: Int?
    let unit: String
    
    var body: some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(value.map { "\($0) \(unit)" } ?? "- \(unit)")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .customFont(color: .gray)
    }
}

#Preview {
    RecommendedProgrammView()
        .environmentObject(ProfileViewModel.shared)
}
