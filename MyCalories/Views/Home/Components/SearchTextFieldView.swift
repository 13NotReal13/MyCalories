//
//  SearchTextFieldView.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import SwiftUI

struct SearchTextFieldView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        TextField("Поиск", text: $homeViewModel.searchText)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color(.systemGray6))
            .clipShape(.capsule)
            .padding(.horizontal)
            .padding(.top, 8)
    }
}
