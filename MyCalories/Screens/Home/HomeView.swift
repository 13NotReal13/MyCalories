//
//  HomeView.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var realmManager: RealmManager
    
    @StateObject var homeViewModel: HomeViewModel
    
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
                    
                    SearchTextFieldView(searchText: $homeViewModel.searchText)
                    
                    ProductsListView(filteredProducts: homeViewModel.filteredProducts)
                }
                
                CircularProgressBarView(
                    profileIsComplete: realmManager.fetchPerson() != nil,
                    protein: homeViewModel.protein,
                    fats: homeViewModel.fats,
                    carbohydrates: homeViewModel.carbohydrates,
                    calories: homeViewModel.calories,
                    water: homeViewModel.water
                )
                
                LeftMenuView(isMenuOpen: $homeViewModel.isMenuOpen)
            }
            .background(BackgroundHeaderView(height: 140))
            .onAppear {
                homeViewModel.fetchRecommendedValues()
            }
            .navigationDestination(for: AppPage.self) { page in
                switch page {
                case .home:
                    HomeView(homeViewModel: homeViewModel)
                case .profile:
                    ProfileView(profileViewModel: ProfileViewModel(realmManager: realmManager))
                }
            }
        }
    }
}

#Preview {
//    HomeView(homeViewModel: HomeViewModel(realmManager: RealmManager.shared))
//        .environmentObject(RealmManager.shared)
}
