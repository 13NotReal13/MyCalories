//
//  BackgroundListView.swift
//  MyCalories
//
//  Created by Иван Семикин on 09/06/2025.
//

import SwiftUI

struct BackgroundListView: View {
    var radius: CGFloat = 8
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.3), radius: radius)
    }
}

#Preview {
    BackgroundListView()
}
