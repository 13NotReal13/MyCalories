//
//  LeftMenuBackgroundView.swift
//  MyCalories
//
//  Created by Иван Семикин on 17/06/2025.
//

import SwiftUI

struct LeftMenuBackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [
                .colorApp,
                .textColorApp
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .roundedCorners(corners: [.topRight, .bottomRight])
        .ignoresSafeArea(edges: .vertical)
        .shadow(color: .black.opacity(0.3), radius: 8)
    }
}
