//
//  HomeView.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
//    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject var homeViewModel: HomeViewModel
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                homeViewModel.isMenuOpen.toggle()
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .foregroundStyle(.white)
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                        }
                    }
                    .customFont(size: 24)
                    .padding(.horizontal)
                    
                    SearchTextFieldView(searchText: $searchText)
                    
                    ProductsListView(filteredProducts: homeViewModel.filteredProducts)
                }
                
                CircularProgressBarView(
                    protein: homeViewModel.protein,
                    fats: homeViewModel.fats,
                    carbohydrates: homeViewModel.carbohydrates,
                    calories: homeViewModel.calories,
                    water: homeViewModel.water
                )
                
                LeftMenuView(isMenuOpen: $homeViewModel.isMenuOpen)
            }
            .background(BackgroundHeaderView(height: 140))
        }
        .navigationDestination(for: AppPage.self) { page in
            switch page {
            case .home:
                HomeView(homeViewModel: .prewiew)
            case .profile:
                ProfileView()
            }
        }
    }
}

#Preview {
    HomeView(homeViewModel: .prewiew)
        .environmentObject(NavigationCoordinator.shared)
}
