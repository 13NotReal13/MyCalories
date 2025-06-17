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
    
    var body: some View {
        ZStack {
            VStack {
                HomeNavigationBarView()
                
                SearchTextFieldView()
                
                ProductsListView()
            }
            
            CircularProgressBarView()
            
            LeftMenuView()
        }
        .environmentObject(viewModel)
        .background(BackgroundHeaderView(height: 140))
    }
}
