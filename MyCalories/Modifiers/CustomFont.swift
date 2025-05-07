//
//  CustomFont.swift
//  MyCalories
//
//  Created by Иван Семикин on 07/05/2025.
//

import Foundation
import SwiftUI

enum CustomFont: String {
    case regular = "InterVariable"
    case bold = "InterDisplay-SemiBold"
}

struct CustomFontModifier: ViewModifier {
    var font: CustomFont
    var size: CGFloat
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.custom(font.rawValue, size: size))
            .foregroundStyle(color)
    }
}

extension View {
    func customFont(font: CustomFont = .regular, size: CGFloat = 17, color: Color = .black) -> some View {
        modifier(CustomFontModifier(font: font, size: size, color: color))
    }
}
