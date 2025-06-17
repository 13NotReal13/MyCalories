//
//  SearchTextFieldView.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import SwiftUI

struct SearchTextFieldView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        TextField("Поиск", text: $viewModel.searchText)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color(.systemGray6))
            .clipShape(.capsule)
            .padding(.horizontal)
            .padding(.top, 16)
    }
}
