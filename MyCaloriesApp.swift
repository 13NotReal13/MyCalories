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
    @StateObject private var coordinator = NavigationCoordinator.shared
    @StateObject private var realmManager = RealmManager.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView(homeViewModel: HomeViewModel(realmManager: realmManager))
                .environmentObject(coordinator)
                .environmentObject(realmManager)
        }
    }
}
