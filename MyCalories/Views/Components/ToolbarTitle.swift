//
//  ToolbarTitle.swift
//  MyCalories
//
//  Created by Иван Семикин on 19/06/2025.
//

import SwiftUI

struct ToolbarTitle: ToolbarContent {
    let title: String
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(title)
                .customFont(font: .bold, size: 19, color: .white)
        }
    }
}
