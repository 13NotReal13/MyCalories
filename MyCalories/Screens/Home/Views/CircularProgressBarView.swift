//
//  CircularProgressBarView.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import SwiftUI

struct CircularProgressBarView: View {
    @State var protein: (used: Int, goal: Int)
    @State var fats: (used: Int, goal: Int)
    @State var carbohydrates: (used: Int, goal: Int)
    @State var calories: (used: Int, goal: Int)
    @State var water: (used: Int, goal: Int)
    
    private var nutrientsData: [(title: String, value: (used: Int, goal: Int), color: Color)] {
        [
            ("Белки", protein, .white),
            ("Жиры", fats, .orange),
            ("Углев.", carbohydrates, .pink),
            ("Ккал.", calories, .yellow),
            ("Вода", water, .blue)
        ]
    }
    
    var body: some View {
        VStack {
            Spacer()
            
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
    }
}

struct NutrientCircleView: View {
    let title: String
    let used: Int
    let goal: Int
    let color: Color
    
    var body: some View {
        let progress = min(Double(used) / Double(goal), 1.0)
        let percentage = Int(progress * 100)
        let isGoalCompleted = used > goal
        
        return VStack {
            Text(title)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 3)
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(width: UIScreen.main.bounds.width * 0.14)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(lineWidth: 3)
                    .foregroundStyle(color)
                    .shadow(color: color, radius: 2)
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
        protein: (0, 100),
        fats: (25, 100),
        carbohydrates: (700, 100),
        calories: (140, 100),
        water: (1347, 3000)
    )
}
