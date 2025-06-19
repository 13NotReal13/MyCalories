//
//  LabelInputWeightView.swift
//  MyCalories
//
//  Created by Иван Семикин on 19/06/2025.
//

import SwiftUI

struct LabelInputWeightView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text("Вес продукта:")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("г.", text: $text)
                .keyboardType(.numberPad)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding(5)
                .background(BackgroundListView(radius: 2))
        }
    }
}
