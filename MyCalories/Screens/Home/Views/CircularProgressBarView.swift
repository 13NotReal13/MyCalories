//
//  CircularProgressBarView.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import SwiftUI

struct CircularProgressBarView: View {
    @Binding var protein: (used: Int, goal: Int)
    @Binding var fats: (used: Int, goal: Int)
    @Binding var carbohydrates: (used: Int, goal: Int)
    @Binding var calories: (used: Int, goal: Int)
    @Binding var water: (used: Int, goal: Int)
    
    private var nutrientsData: [(title: String, value: (used: Int, goal: Int), color: Color)] {
        [
            ("Белки", protein, .white),
            ("Жиры", fats, .yellow),
            ("Углев.", carbohydrates, .orange),
            ("Ккал.", calories, .yellow),
            ("Вода", water, .blue)
        ]
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .foregroundStyle(.colorApp)
                    .ignoresSafeArea()
                    .frame(height: 130)
                    .shadow(color: .black.opacity(0.5), radius: 5)
                
                HStack(spacing: 16) {
                    ForEach(nutrientsData, id: \.title) { nutrient in
                        VStack {
                            Text(nutrient.title)
                            
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 3)
                                    .foregroundStyle(nutrient.color.opacity(0.7))
                                    .frame(width: 60)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CircularProgressBarView(
        protein: .constant((0, 100)),
        fats: .constant((0, 100)),
        carbohydrates: .constant((0, 100)),
        calories: .constant((0, 100)),
        water: .constant((0, 100))
    )
}
