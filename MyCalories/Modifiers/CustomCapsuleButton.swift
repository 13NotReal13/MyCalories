//
//  CustomCapsuleButton.swift
//  MyCalories
//
//  Created by Иван Семикин on 10/06/2025.
//

import Foundation
import SwiftUI

struct CustomCapsuleButtonModifier: ViewModifier {
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 12)
            .padding(.horizontal, 28)
            .background(
                Capsule()
                    .foregroundStyle(backgroundColor)
                    .shadow(color: .black.opacity(0.3), radius: 2)
            )
    }
}

extension View {
    func customCapsuleButton(backgroundColor: Color = .colorApp) -> some View {
        modifier(CustomCapsuleButtonModifier(backgroundColor: backgroundColor))
    }
}
