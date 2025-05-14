//
//  SearchTextFieldView.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2025.
//

import SwiftUI

struct SearchTextFieldView: View {
    @Binding var searchText: String
    
    var body: some View {
        TextField("Поиск", text: $searchText)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color(.systemGray6))
            .clipShape(.capsule)
            .padding(.horizontal)
            .padding(.top, 8)
    }
}

#Preview {
    SearchTextFieldView(searchText: .constant("some product"))
}
