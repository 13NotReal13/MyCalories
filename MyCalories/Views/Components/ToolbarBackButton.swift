//
//  ToolbarBackButton.swift
//  MyCalories
//
//  Created by Иван Семикин on 19/05/2025.
//

import SwiftUI

struct ToolbarBackButton: ToolbarContent {
    let title: String
    let dismiss: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
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
}
