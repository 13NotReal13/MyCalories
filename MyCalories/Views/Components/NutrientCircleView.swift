//
//  NutrientCircleView.swift
//  MyCalories
//
//  Created by Иван Семикин on 17/06/2025.
//

import SwiftUI

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
