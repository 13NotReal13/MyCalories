//
//  NavigationCoordinator.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import Foundation
import SwiftUI

enum AppPage {
    case home
}

final class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    static let shared = NavigationCoordinator()
    
    func view(for page: AppPage) -> some View {
        switch page {
        case .home: HomeView(homeViewModel: .prewiew)
        }
    }
    
    func push(_ page: AppPage) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
}
