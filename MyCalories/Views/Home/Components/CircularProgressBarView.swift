//
//  CircularProgressBarView.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import SwiftUI

struct CircularProgressBarView: View {
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    
    var profileIsComplete: Bool
    let protein: (used: Int, goal: Int)
    let fats: (used: Int, goal: Int)
    let carbohydrates: (used: Int, goal: Int)
    let calories: (used: Int, goal: Int)
    let water: (used: Int, goal: Int)
    
    private var nutrientsData: [(title: String, value: (used: Int, goal: Int), color: Color)] {
        [
            ("Белки", protein, .white),
            ("Жиры", fats, .orange),
            ("Углев.", carbohydrates, Color(UIColor.cyan)),
            ("Ккал.", calories, .yellow),
            ("Вода", water, Color(UIColor.blue))
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
                .opacity(profileIsComplete ? 1 : 0.1)
                
                if !profileIsComplete {
                    VStack {
                        Text("Для отображения дневной статистики необходимо заполнить профиль")
                            .padding()
                            .multilineTextAlignment(.center)
                            .customFont(size: 17, color: .white)
                        
                        Button {
                            navigationCoordinator.push(.profile)
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

struct NutrientCircleView: View {
    let title: String
    let used: Int
    let goal: Int
    let color: Color
    
    var body: some View {
        let progress: Double
        if goal > 0 {
            progress = min(Double(used) / Double(goal), 1.0)
        } else {
            progress = 0.0
        }
        
        let percentage = Int(progress * 100)
        let isGoalCompleted = used > goal
        
        return VStack {
            Text(title)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 3)
                    .foregroundStyle(.white.opacity(0.2))
                    .frame(width: UIScreen.main.bounds.width * 0.14)
                    .shadow(color: color, radius: 1)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(lineWidth: 3)
                    .foregroundStyle(color)
                    .frame(width: UIScreen.main.bounds.width * 0.14)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: progress)
                
                Text("\(percentage)%")
                    .customFont(font: .bold, size: 15, color: percentage >= 100 ? .yellow : .white)
            }
            
            Text("\(used)\(isGoalCompleted ? " !" : "")")
                .foregroundStyle(isGoalCompleted ? .yellow : .white)
            
            Text(String(goal))
                .foregroundStyle(.white.opacity(0.7))
        }
        .customFont(size: 13, color: .white)
    }
}

#Preview {
    CircularProgressBarView(
        profileIsComplete: true,
        protein: (50, 100),
        fats: (0, 100),
        carbohydrates: (0, 100),
        calories: (0, 100),
        water: (0, 3000)
    )
    .environmentObject(NavigationCoordinator())
}
