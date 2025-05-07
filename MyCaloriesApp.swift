//
//  MyCaloriesApp.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import Foundation
import SwiftUI

@main
struct MyCaloriesApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(homeViewModel: .prewiew)
        }
    }
}
