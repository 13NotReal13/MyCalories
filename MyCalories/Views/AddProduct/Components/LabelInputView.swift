//
//  LabelInputView.swift
//  MyCalories
//
//  Created by Иван Семикин on 19/06/2025.
//

import SwiftUI

struct LabelInputView: View {
    let title: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("г.", text: $value)
                .keyboardType(.numberPad)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding(5)
                .background(BackgroundListView(radius: 2))
        }
        .customFont()
    }
}
