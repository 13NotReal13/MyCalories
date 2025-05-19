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
    
    var body: some View {
        HStack {
            Text(title)
                .customFont()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: onTap) {
                Text(value.isEmpty ? "выбрать" : value)
                    .customFont(color: .gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(5)
                    .background {
                        Color.white
                            .roundedCorners(radius: 8)
                            .shadow(color: .black.opacity(0.2), radius: 3)
                    }
            }
        }
    }
}
