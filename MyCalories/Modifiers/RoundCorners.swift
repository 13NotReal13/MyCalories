//
//  RoundCorners.swift
//  MyCalories
//
//  Created by Иван Семикин on 11/05/2025.
//

import Foundation
import SwiftUI

struct RoundedCorners: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorners(radius: CGFloat = 30, corners: UIRectCorner = .allCorners) -> some View {
        clipShape(RoundedCorners(radius: radius, corners: corners))
    }
}
