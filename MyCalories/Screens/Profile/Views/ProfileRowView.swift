//
//  ProfileRowView.swift
//  MyCalories
//
//  Created by Иван Семикин on 12/05/2025.
//

import SwiftUI

struct ProfileRowView: View {
    var title: String
    var value: String
    var onTap: () -> Void
    
    private var shadowColor: Color {
        return value == "выбрать" ? Color.yellow : Color.black.opacity(0.2)
    }
    
    var body: some View {
        HStack {
            Text(title)
                .customFont()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: onTap) {
                Text(value)
                    .customFont(color: value == "выбрать" ? .gray : .black.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(5)
                    .background {
                        Color.white
                            .roundedCorners(radius: 8)
                            .shadow(color: shadowColor, radius: 3)
                    }
            }
        }
    }
}
