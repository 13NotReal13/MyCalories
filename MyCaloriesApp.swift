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
    @StateObject private var realm: RealmManager
    @StateObject private var coordinator: Coordinator
    
    init() {
        let realmManager = RealmManager()
        _realm = StateObject(wrappedValue: realmManager)
        _coordinator = StateObject(wrappedValue: Coordinator(realm: realmManager))
    }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .environmentObject(coordinator)
        }
    }
}
