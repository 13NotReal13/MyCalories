//
//  HomeNavigationBarView.swift
//  MyCalories
//
//  Created by Иван Семикин on 17/06/2025.
//

import SwiftUI

struct HomeNavigationBarView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
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
        }
        .customFont(size: 24)
        .padding(.horizontal)
    }
}
