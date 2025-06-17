//
//  Coordinator.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import Foundation
import SwiftUI

enum Page: String, Identifiable {
    case home
    case profile
    
    var id: String {
        return self.rawValue
    }
}

enum Sheet: Identifiable {
    case addProduct(Product)
    
    var id: String {
        switch self {
        case .addProduct(let product):
            return "\(product.name) \(product.index)"
        }
    }
}

enum FullScreenCover: String, Identifiable {
    case fullSome
    
    var id: String {
        return self.rawValue
    }
}

final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    var realm: RealmManager
    
    init(realm: RealmManager) {
        self.realm = realm
    }
    
    func push(_ page: Page) {
        path.append(page)
    }
    
    func present(sheet: Sheet) {
        self.sheet = sheet
    }
    
    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        sheet = nil
    }
    
    func dismissFullScreenCover() {
        fullScreenCover = nil
    }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .home:
            HomeView(viewModel: HomeViewModel(realmManager: self.realm))
        case .profile:
            ProfileView(viewModel: ProfileViewModel(realmManager: self.realm))
        }
    }
    
    @ViewBuilder
    func build(sheet: Sheet) -> some View {
        switch sheet {
        case .addProduct(let product):
            let viewModel = AddProductViewModel(realmManager: realm, selectedProduct: product)
            AddProductView(addProductViewModel: viewModel)
        }
    }
    
    @ViewBuilder
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .fullSome:
            Text("Full Screen")
        }
    }
}
