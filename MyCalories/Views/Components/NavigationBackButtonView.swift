//
//  NavigationBackButtonView.swift
//  MyCalories
//
//  Created by Иван Семикин on 19/05/2025.
//

import SwiftUI

struct NavigationBackButtonView: View {
    let title: String
    let dismiss: () -> Void
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                Text(title)
            }
            .customFont(color: .white)
        }
    }
}
