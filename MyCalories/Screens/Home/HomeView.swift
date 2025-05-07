//
//  HomeView.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var coordinator = NavigationCoordinator.shared
//    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject var homeViewModel: HomeViewModel
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                VStack {
                    SearchTextFieldView(searchText: $searchText)
                    
                    ProductsListView(filteredProducts: homeViewModel.filteredProducts)
                }
                
                CircularProgressBarView(
                    protein: $homeViewModel.protein,
                    fats: $homeViewModel.fats,
                    carbohydrates: $homeViewModel.carbohydrates,
                    calories: $homeViewModel.calories,
                    water: $homeViewModel.water
                )
            }
            .background {
                VStack {
                    RoundedRectangle(cornerRadius: 60)
                        .foregroundStyle(.colorApp)
                        .ignoresSafeArea()
                        .frame(height: 120)
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(.white)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .navigationDestination(for: AppPage.self) { page in
            coordinator.view(for: page)
        }
    }
}

#Preview {
    HomeView(homeViewModel: .prewiew)
}
