//
//  HomeView.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var realm: RealmManager
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                viewModel.isMenuOpen.toggle()
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
                    
                    SearchTextFieldView()
                    
                    ProductsListView()
                }
                
                CircularProgressBarView(
                    profileIsComplete: viewModel.isProgressBarUnlocked(),
                    protein: viewModel.protein,
                    fats: viewModel.fats,
                    carbohydrates: viewModel.carbohydrates,
                    calories: viewModel.calories,
                    water: viewModel.water
                )
                
                LeftMenuView(isMenuOpen: $viewModel.isMenuOpen)
            }
            .environmentObject(viewModel)
            .background(BackgroundHeaderView(height: 140))
            .onAppear {
                viewModel.fetchUsedTodayNutrients()
                viewModel.fetchRecommendedValues()
            }
        }
    }
}

#Preview {
//    HomeView(homeViewModel: HomeViewModel(realmManager: RealmManager.shared))
//        .environmentObject(RealmManager.shared)
}
