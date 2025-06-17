//
//  CircularProgressBarView.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import SwiftUI

struct CircularProgressBarView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var viewModel: HomeViewModel
    
    private var nutrientsData: [(title: String, value: (used: Int, goal: Int), color: Color)] {
        [
            ("Белки", viewModel.protein, .white),
            ("Жиры", viewModel.fats, .orange),
            ("Углев.", viewModel.carbohydrates, Color(UIColor.cyan)),
            ("Ккал.", viewModel.calories, .yellow),
            ("Вода", viewModel.water, Color(UIColor.blue))
        ]
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                HStack {
                    Spacer()
                    
                    ForEach(nutrientsData, id: \.title) { nutrient in
                        NutrientCircleView(
                            title: nutrient.title,
                            used: nutrient.value.used,
                            goal: nutrient.value.goal,
                            color: nutrient.color
                        )
                        Spacer()
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 24)
                .opacity(viewModel.isProgressBarUnlocked() ? 1 : 0.1)
                
                if !viewModel.isProgressBarUnlocked() {
                    VStack {
                        Text("Для отображения дневной статистики необходимо заполнить профиль")
                            .padding()
                            .multilineTextAlignment(.center)
                            .customFont(size: 17, color: .white)
                        
                        Button {
                            coordinator.push(.profile)
                        } label: {
                            Text("Профиль")
                                .customFont(font: .bold, color: .white)
                        }
                    }
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 30)
                    .fill (
                        LinearGradient(
                            colors: [
                                .colorApp,
                                .textColorApp
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea(edges: .bottom)
                    .shadow(color: .black.opacity(0.4), radius: 8)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
