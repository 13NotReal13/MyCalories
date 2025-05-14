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
    case profile
}

enum AppModal {
    case profilePicker(display: PickerModalDisplay)
}

final class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var activeModal: AppModal?
    
    static let shared = NavigationCoordinator()
    
    func push(_ page: AppPage) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func presentModal(_ modal: AppModal) {
        activeModal = modal
    }
    
    func dismissModal() {
        activeModal = nil
    }
}
